package jwh.referencetool;

import java.io.*;
import java.util.*;
import java.awt.*;
import java.awt.List;
import java.awt.event.*;
import java.net.MalformedURLException;
import java.net.URL;

import javax.swing.*;
import javax.swing.text.*;
import javax.swing.event.*;
import javax.swing.tree.*;

import processing.app.exec.SystemOutSiphon;
import processing.app.Base;
import processing.app.Platform;
import processing.app.tools.Tool;
import processing.app.ui.Editor;
import processing.app.ui.Toolkit;
import processing.app.Sketch;
import processing.app.SketchCode;

public class SplitPane extends JFrame{
	ArrayList<Header> listofHeaders = new ArrayList<Header>();
	Editor editor;
	Base base;
	DefaultTreeModel treeModel;
	SetHTML htmlPane = new SetHTML();
	DefaultMutableTreeNode Root;
	JTree tree;
	Boolean filtered = false;

	JComboBox<DefaultMutableTreeNode> searchBar;
	
	JTextArea textArea = new JTextArea();
	JButton reset;
	JButton search;
	JLabel filterLabel;
	JButton removeFilter;
	JCheckBox searchAll;
	boolean mustSearchAll = false;
	boolean initiated = false;
	JScrollPane leftscrollPane;
	JScrollPane rightscrollPane;
	JPanel rightpanel;
	JComponent panel;
	ArrayList<String> referenceList = new ArrayList<String>();
	ArrayList<Leaf> trackLeaves = new ArrayList<Leaf>();
	HashSet<String> headerSubheaderNames = new HashSet<String>();
	String splashhtml;
	FilterTree newFilter;
	
	int open = 0;
	int openLocation = 0;
	
	
	public SplitPane(Base baseInput) {
		this.setTitle("References");
		base = baseInput;
		setGUI();
		this.setVisible(true);
		this.setResizable(false);
	}
	
	/*
	 * Set up GUI
	 */
	private void setGUI() {
		Font htmlfont = Toolkit.getSansFont(9, Font.PLAIN);
		
		Root = new DefaultMutableTreeNode("12345");
		// read in all references and connect all nodes
		setTree();
		treeModel = new DefaultTreeModel(Root);
		tree = new JTree(treeModel);
	
		tree.setRootVisible(false);
		// root may be invisible but keep arrows
		tree.setShowsRootHandles(true);
		// keep click count to 1
		tree.setToggleClickCount(1);
		tree.getSelectionModel().addTreeSelectionListener(new Selector());
		tree.getSelectionModel().setSelectionMode(TreeSelectionModel.SINGLE_TREE_SELECTION);
		
		// get rid of folders 
		DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
		renderer.setLeafIcon(null);
		renderer.setClosedIcon(null);
		renderer.setOpenIcon(null);
		
		JPanel leftpanel = new JPanel();
		rightpanel = new JPanel();
		  
		leftpanel.setLayout(new BoxLayout(leftpanel, BoxLayout.Y_AXIS));
		rightpanel.setLayout(new BorderLayout());
		
		searchAll = new JCheckBox("Search All");
		java.net.URL htmlURL = getClass().getResource("/data/splash.html");
		
		try {
			splashhtml = splashHTML(htmlURL);
		} catch (IOException e) {
			e.printStackTrace();
		}

		// add document listener to track key movements
		textArea.getDocument().addDocumentListener(new DocListener());
		reset = new JButton("RESET");
		reset.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				collapseAll(tree);
				searchAll.setSelected(false);
				mustSearchAll = false;
				((JTextField) searchBar.getEditor().getEditorComponent()).setText("");
				filterLabel.setVisible(true);
				removeFilter.setVisible(false);
				htmlPane.setText(splashhtml);
				if(panel != null) {
					panel.removeAll();
					panel.revalidate();
				}
			}
		});
				
		// adding search button and search all checkbox
		JPanel buttonCheckPanel = new JPanel();
		buttonCheckPanel.setLayout(new BoxLayout(buttonCheckPanel, BoxLayout.LINE_AXIS));
		buttonCheckPanel.setBorder(BorderFactory.createEmptyBorder(0, 5, 0, 5));
		buttonCheckPanel.add(searchAll);
		buttonCheckPanel.add(Box.createRigidArea(new Dimension(20, 0)));
		buttonCheckPanel.add(reset);
		
		// establishing the search bar and its layout
		searchBar = new JComboBox<DefaultMutableTreeNode>();
		JPanel savedSearchesPanel = new JPanel();
		savedSearchesPanel.setLayout(new BoxLayout(savedSearchesPanel, BoxLayout.LINE_AXIS));
		savedSearchesPanel.add(searchBar);

		searchBar.setEditable(true);
		searchBar.setMaximumRowCount(5);

		((JTextField) searchBar.getEditor().getEditorComponent()).addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				int selStart = textArea.getSelectionStart();
				int selEnd = textArea.getSelectionEnd();
				if(searchBar.getSelectedItem() != null) {
					textArea.replaceRange(searchBar.getSelectedItem().toString(), selStart, selEnd);
					((JTextField) searchBar.getEditor().getEditorComponent()).selectAll();
				}
			}
		});
		
		
		// processing/app/src/processing/contrib/ContributionTab.java
		// lines 351 - 403
		filterLabel = new JLabel("<html><font color='gray'>Search</font></html>");
		filterLabel.setOpaque(false);
		filterLabel.setIcon(Toolkit.getLibIconX("manager/search"));
		removeFilter = Toolkit.createIconButton("manager/remove");
		removeFilter.setBorder(BorderFactory.createEmptyBorder(0,0,0,2));
		removeFilter.setBorderPainted(false);
		removeFilter.setContentAreaFilled(false);
		removeFilter.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				((JTextField) searchBar.getEditor().getEditorComponent()).setText("");
				searchBar.requestFocusInWindow();
			}
		});
		
		removeFilter.setVisible(false);
		
		searchBar.setOpaque(false);
		
		GroupLayout fl = new GroupLayout((JTextField) searchBar.getEditor().getEditorComponent());
		((JTextField) searchBar.getEditor().getEditorComponent()).setLayout(fl);
		fl.setHorizontalGroup(fl.createSequentialGroup()
								.addComponent(filterLabel)
								.addPreferredGap(LayoutStyle.ComponentPlacement.RELATED,
				                         GroupLayout.PREFERRED_SIZE, Short.MAX_VALUE)
								.addComponent(removeFilter));
		
		fl.setVerticalGroup(fl.createSequentialGroup()
                .addPreferredGap(LayoutStyle.ComponentPlacement.RELATED,
                                 GroupLayout.PREFERRED_SIZE, Short.MAX_VALUE)
                .addGroup(fl.createParallelGroup()
                .addComponent(filterLabel)
                .addComponent(removeFilter))
                .addPreferredGap(LayoutStyle.ComponentPlacement.RELATED,
                                 GroupLayout.PREFERRED_SIZE, Short.MAX_VALUE));
		
		((JTextField) searchBar.getEditor().getEditorComponent()).addFocusListener(new FocusListener() {
			public void focusLost(FocusEvent focusEvent) {
				if(((JTextField) searchBar.getEditor().getEditorComponent()).getText().isEmpty()) {
					filterLabel.setVisible(true);
				}
			}
			public void focusGained(FocusEvent focusEvent) {
				filterLabel.setVisible(false);
			}
		});
		
		Document document = ((JTextField) searchBar.getEditor().getEditorComponent()).getDocument();
		document.addDocumentListener(new DocListener());		
		
		leftscrollPane = new JScrollPane(tree);
		rightscrollPane = new JScrollPane(htmlPane);
		htmlPane.setFont(htmlfont);

		rightpanel.add(rightscrollPane, BorderLayout.CENTER);
		
		// left side layout
		searchBar.setAlignmentX(Component.CENTER_ALIGNMENT);
		leftpanel.add(savedSearchesPanel);
		buttonCheckPanel.setAlignmentX(Component.CENTER_ALIGNMENT);
		leftpanel.add(buttonCheckPanel);
		leftscrollPane.setAlignmentX(Component.CENTER_ALIGNMENT);
		leftpanel.add(leftscrollPane);
		
		// set left and right
		JSplitPane splitPane = new JSplitPane(JSplitPane.HORIZONTAL_SPLIT);
		splitPane.setLeftComponent(leftpanel);
		splitPane.setRightComponent(rightpanel);

		// splash page
		htmlPane.setText(splashhtml);
		htmlPane.setEditable(false);
		
		splitPane.setDividerLocation(200);
		splitPane.setDividerSize(2);
		
		splitPane.setPreferredSize(new Dimension(770,400));
		
		this.getContentPane().add(splitPane);
		
		// reading in all html to start and saving it 
		readinAllHTML();
		
		newFilter = new FilterTree(Root, treeModel, tree, leftscrollPane, htmlPane, headerSubheaderNames, filtered);

		// adding function to click searchall whenever and make tree update accordingly
		searchAll.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				if(searchAll.isSelected()) {
					newFilter.filterTree(((JTextField) searchBar.getEditor().getEditorComponent()).getText(), searchAll);
				} else {
					newFilter.filterTree(((JTextField) searchBar.getEditor().getEditorComponent()).getText(), searchAll);
				}
			}
		});
	}
	
	/*
	 * Reading in reference lists for headers and subheaders to set the tree
	 */
	private void readinLists() {
		java.net.URL htmlURL = getClass().getResource("/data/referencetext/reference_summary.txt");
				
		try (BufferedReader br = new BufferedReader(new InputStreamReader(htmlURL.openStream()))){
			String line;
			while((line = br.readLine()) != null) {
				Header newheader = new Header(line);
				headerSubheaderNames.add(line);
				Root.add(newheader.getHeader());
				line = br.readLine();
				newheader.setMisc(Integer.parseInt(line));
				line = br.readLine();
				Integer numofsubHeaders = Integer.parseInt(line);
				
				if(numofsubHeaders != 0) {
					newheader.setNumberofSubHeaders(numofsubHeaders);
					LinkedHashMap<SubHeader, Integer> tempHashMap = new LinkedHashMap<SubHeader, Integer>();
					for(int i = 0; i < numofsubHeaders; i++) {
						line = br.readLine();
						SubHeader tempSubHeader = new SubHeader(line);
						headerSubheaderNames.add(line);
						line = br.readLine();
						Integer number = Integer.parseInt(line);
						tempHashMap.put(tempSubHeader, number);
					}
					newheader.setSubHeaderNumber(tempHashMap);
				}
				
				newheader.addSubHeaders();
				listofHeaders.add(newheader);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/*
	 * Reading in the rest of the references for Headers and Subheaders
	 */
	private void assignReferences() {
		java.net.URL htmlURL = getClass().getResource("/data/referencetext/reference_list.txt");
		int counter = 0;
		
		try(BufferedReader br = new BufferedReader(new InputStreamReader(htmlURL.openStream()))) {
			String line;
			while((line = br.readLine()) != null) {
				referenceList.add(line);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		for(int i = 0; i < listofHeaders.size(); i++) {
			// per header
			Header tempHeader = listofHeaders.get(i);
			LinkedHashMap<SubHeader, Integer> tempSubHeaders = tempHeader.getSubHeaderNumber();
			// check misc
			int tempHeaderMiscNum = tempHeader.getMisc();
			// if misc not 0
			if(tempHeader.getMisc() != 0) {
				for(int j = counter; j < tempHeaderMiscNum + counter; j++) {
					// add misc references
					Leaf newleaf = new Leaf(referenceList.get(j));
					if(referenceList.get(j).indexOf('`') >= 0) {
						trackLeaves.add(newleaf);
					}
					
					tempHeader.addMiscLeaves(newleaf);
				}
			}
			
			counter += tempHeaderMiscNum;
			
			// check for subheaders and if number of subheaders is not 0
			if(tempHeader.getNumberofSubHeaders()!=0) {
				// per subhead
				for(Map.Entry<SubHeader, Integer> entry : tempSubHeaders.entrySet()) {
					SubHeader tempSubHead = entry.getKey();
					Integer tempSubHeadNum = entry.getValue();
					ArrayList<Leaf> inputList = new ArrayList<Leaf>();
					for(int j = counter; j < tempSubHeadNum + counter; j++) {
						// add reference
						String tempString = referenceList.get(j);
						Leaf newleaf = new Leaf(tempString);
						if(tempString.indexOf('`') >= 0) {
							trackLeaves.add(newleaf);
						}
						inputList.add(newleaf);
					}
					
					tempSubHead.addLeaves(inputList);
					counter += tempSubHeadNum;
				}
			}
		}
	}
	
	/*
	 * Reading in Methods and Fields references for some references
	 */
	private void assignleafMiscs() {
		java.net.URL htmlURL = getClass().getResource("/data/referencetext/leafmiscs.txt");
		ArrayList<String> listofmiscs = new ArrayList<String>();
		
		int counter = 0;
		
		try(BufferedReader br = new BufferedReader(new InputStreamReader(htmlURL.openStream()))) {
			String line;
			String[] output;
			
			int count = 0;
			while((line = br.readLine()) != null) {
				if(line.indexOf('_') >= 0) {
					output = line.split("_");
					for(Leaf currentleaf : trackLeaves) {
						String currentleafName = currentleaf.getLeaf().toString();
						if(currentleafName.equals(output[0])) {
							if(output[1].indexOf(',') == -1) {
								Integer numberofMethods = Integer.parseInt(output[1]);
								
								ArrayList<DefaultMutableTreeNode> methods = new ArrayList<DefaultMutableTreeNode>();
								for(int i = 0; i < numberofMethods; i++) {
									line = br.readLine();
									DefaultMutableTreeNode newnode = new DefaultMutableTreeNode(line);
									methods.add(newnode);
								}
								
								currentleaf.addLeafMethods(methods);
							} else {
								String[] parsed = output[1].split(",");
								Integer numberofFields = Integer.parseInt(parsed[0]);
								Integer numberofMethods = Integer.parseInt(parsed[1]);
								
								ArrayList<DefaultMutableTreeNode> methods = new ArrayList<DefaultMutableTreeNode>();
								ArrayList<DefaultMutableTreeNode> fields = new ArrayList<DefaultMutableTreeNode>();
								
								for(int i = 0; i < numberofFields; i++) {
									line = br.readLine();
									DefaultMutableTreeNode newnode = new DefaultMutableTreeNode(line);
									fields.add(newnode);
								}
								
								for(int i = 0; i < numberofMethods; i++) {
									line = br.readLine();
									DefaultMutableTreeNode newnode = new DefaultMutableTreeNode(line);
									methods.add(newnode);
								}
								
								currentleaf.addLeafMethods(methods);
								currentleaf.addLeafFields(fields);
							}
						}
					}
				}
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/*
	 * Connecting all nodes together
	 */
	private void setTree() {
		readinLists();
		assignReferences();
		assignleafMiscs();
		for(Header head : listofHeaders) {
			head.connectNodes();
		}
	}
	
	/*
	 * Setting html on the right as well as creating example try buttons and tying it to a new editor
	 */
	private void setFile(String nodeName, String original) {
		htmlPane.parseHTML(null, nodeName, initiated, searchAll.isSelected(), ((JTextField) searchBar.getEditor().getEditorComponent()).getText());  
		
		HashMap<String, ArrayList<String>> mapofCodes = htmlPane.getMapofCodes();
		ArrayList<String> exampleCodes = null;
		if(mapofCodes.containsKey(nodeName)) {
			exampleCodes = mapofCodes.get(nodeName);
		}
		
		if(exampleCodes.size() != 0) {
			panel = Box.createHorizontalBox();
			panel.setBackground(new Color(245, 245, 245));
			JPanel panelButtons = new JPanel();
			panelButtons.setLayout(new BoxLayout(panelButtons, BoxLayout.LINE_AXIS));

			panelButtons.add(Box.createRigidArea(new Dimension(10,0)));
			panelButtons.add(Box.createHorizontalGlue());
			
			for(int i = 0; i < exampleCodes.size(); i++) {
				JButton newbutton;
				final String exampleCode = exampleCodes.get(i);
				
				newbutton = new JButton(Integer.toString(i+1));
				newbutton.addActionListener(new ActionListener() {
					@Override
					public void actionPerformed(ActionEvent e) {
						// if open is 0, that means it hasn't previously been opened yet
						if(open == 0) {
							base.handleNew();
							openLocation = base.getEditors().size() - 1;
						}
						open = 1;
						
						// if the the editor number is lower than the actual number of editors open rn,
						// then retrieve that editor to populate the example text
						if(openLocation < base.getEditors().size()) {
							Editor editor = base.getEditors().get(openLocation);
							
							editor.setText(exampleCode);
							editor.requestFocus();
						// if the editor number is higher than the actual number of editors open rn,
						// then open a new editor to populate the example text and remember that location instead
						} else {
							base.handleNew();
							openLocation = base.getEditors().size() - 1;
							Editor editor = base.getEditors().get(openLocation);
							
							editor.setText(exampleCode);
							editor.requestFocus();
						}
					}
				});
				newbutton.setActionCommand(Integer.toString(i));
				panelButtons.add(newbutton);
			}
			
			panel.add(panelButtons);
			rightpanel.add(panel, BorderLayout.PAGE_END);
			panel.revalidate();
			
		} else {
			// if there are no examples but the panel is still populated, erase the buttons
			if(panel != null) {
				panel.removeAll();
			}
		}
	}
	
	public void handleClose() {
		dispose();
	}

	/*
	 * Reading in all html reference files provided by Processing
	 */
	public void readinAllHTML() {
		Enumeration e = Root.preorderEnumeration();
		
		while(e.hasMoreElements()) {
			DefaultMutableTreeNode node = (DefaultMutableTreeNode) e.nextElement();
			
			String nodeName = "";
			String htmlfileName = "";
			NodeNameGenerator gen = new NodeNameGenerator(headerSubheaderNames);
			nodeName = gen.generator(node);
			if(node.isLeaf()) {
				htmlfileName = "modes/java/reference/"+nodeName+".html";
				File htmlfile = Platform.getContentFile(htmlfileName);
				java.net.URL htmlURL = null;
				if(htmlfile.exists()) {
					try {
						htmlURL = htmlfile.toURI().toURL();
					} catch (MalformedURLException malE) {
						malE.printStackTrace();
					} 
				} else {
					nodeName = nodeName.substring(0, nodeName.length()-1);
					nodeName = nodeName + "convert_";
					htmlfileName = "modes/java/reference/" + nodeName + ".html";
					htmlfile = Platform.getContentFile(htmlfileName);
					if(htmlfile.exists()) {
						try {
							htmlURL = htmlfile.toURI().toURL();
						} catch (MalformedURLException malE) {
							malE.printStackTrace();
						} 
					} 
				}

				htmlPane.parseHTML(htmlURL, nodeName, initiated, false, "");
			} else {
				if(!node.isRoot() 
						&& !node.toString().equals("Methods") 
						&& !node.toString().equals("Fields")
						&& !headerSubheaderNames.contains(node.toString())) {
					htmlfileName = "modes/java/reference/" + nodeName + ".html";
					File htmlfile = Platform.getContentFile(htmlfileName);
					java.net.URL htmlURL = null;
					if(htmlfile.exists()) {
						try {
							htmlURL = htmlfile.toURI().toURL();
						} catch (MalformedURLException malE) {
							malE.printStackTrace();
						}
					} else {
						nodeName = nodeName.substring(0, nodeName.length()-1);
						nodeName = nodeName + "convert_";
						htmlfileName = "modes/java/reference/" + nodeName + ".html";
						htmlfile = Platform.getContentFile(htmlfileName);
						if(htmlfile.exists()) {
							try {
								htmlURL = htmlfile.toURI().toURL();
							} catch (MalformedURLException malE) {
								malE.printStackTrace();
							} 
						}
					}

					htmlPane.parseHTML(htmlURL, nodeName, initiated, false, "");
				}
			}
		}
	}
	
	/*
	 * Getting the splash page html
	 */
	private static String splashHTML(URL htmlURL) throws IOException {
		BufferedReader in = new BufferedReader(new InputStreamReader(htmlURL.openStream()));
		String line;
		StringBuilder stringBuilder = new StringBuilder();
		String ls = System.getProperty("line.separator");
		
		try {
			while ((line = in.readLine()) != null) {
				stringBuilder.append(line);
				stringBuilder.append(ls);
			}
			
			return stringBuilder.toString();
		} finally {
			in.close();
		}
	}
	
	/*
	 * Tree selector implementation
	 */
	private class Selector implements TreeSelectionListener {
		public void valueChanged(TreeSelectionEvent e) {

			if(panel != null) 
				panel.removeAll();
		
			initiated = true;
			
			DefaultMutableTreeNode node = (DefaultMutableTreeNode) tree.getLastSelectedPathComponent();
		
			if (node == null) 
				return;
			
			NodeNameGenerator gen = new NodeNameGenerator(headerSubheaderNames);
			String nodeName = gen.generator(node);
			
			String htmlfileName = null;
			
			if(node.isLeaf()) {
				DefaultMutableTreeNode nodeParent = (DefaultMutableTreeNode) node.getParent();
				DefaultMutableTreeNode nodeGParent = (DefaultMutableTreeNode) nodeParent.getParent();

				String currentText = ((JTextField) searchBar.getEditor().getEditorComponent()).getText();
			
				setFile(nodeName, node.toString());
				
				SwingUtilities.invokeLater(new Runnable() {
				    public void run() {
				        searchBar.insertItemAt(node, 0);
				        
				        if(searchBar.getItemCount() == 6) {
							searchBar.removeItemAt(5);
						}
				    }
				});
				
			} else {
				// making sure not to open up nonexisting html files for folders with names "Methods" and "Fields"
				if(!node.isRoot() 
						&& !node.toString().equals("Methods") 
						&& !node.toString().equals("Fields")
						&& !headerSubheaderNames.contains(node.toString())) {
					setFile(nodeName, node.toString());
					
					SwingUtilities.invokeLater(new Runnable() {
					    public void run() {
					        searchBar.insertItemAt(node, 0);
					        
					        if(searchBar.getItemCount() == 6) {
								searchBar.removeItemAt(5);
							}
					    }
					});
				}
			}
		}
	}
	
	/*
	 * Closing all open rows 
	 */
	private void collapseAll(JTree tree) {
		treeModel.setRoot(Root);
		tree.setModel(treeModel);
		
		DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
		renderer.setLeafIcon(null);
		renderer.setClosedIcon(null);
		
		renderer.setOpenIcon(null);

		int row = tree.getRowCount() - 1;
		while(row >= 0) {
			tree.collapseRow(row);
			row--;
		}
	}
	
	/*
	 * To make tree unclickable before pressing the Search Button
	 * https://stackoverflow.com/questions/10985734/java-swing-enabling-disabling-all-components-in-jpanel
	 * Andrew Thompson
	 */
	private static void enableComponents(Container container, boolean enable) {
		Component[] components = container.getComponents();
		for(Component component : components) {
			component.setEnabled(enable);
			if(component instanceof Container) {
				enableComponents((Container) component, enable);
			}
		}
	}

	/*
	 * Document listener that listens to key stroke changes and filters tree accordingly
	 */
	private class DocListener implements DocumentListener {
		public void insertUpdate(DocumentEvent e) {
			newFilter.filterTree(((JTextField) searchBar.getEditor().getEditorComponent()).getText(), searchAll);
		}
		
		public void removeUpdate(DocumentEvent e) {
			newFilter.filterTree(((JTextField) searchBar.getEditor().getEditorComponent()).getText(), searchAll);
		}
		
		public void changedUpdate(DocumentEvent e) {
		}
	}
}