package jwh.referencetool;

import javax.swing.*;
import javax.swing.tree.*;
import java.io.*;
import java.util.*;

public class FilterTree {
	DefaultMutableTreeNode Root;
	DefaultTreeModel treeModel;
	JTree tree;
	JScrollPane leftscrollPane;
	SetHTML htmlPane;
	HashSet<String> headerSubheaderNames;
	boolean filtered;
	
	public FilterTree(DefaultMutableTreeNode Root, DefaultTreeModel treeModel, JTree tree, 
			JScrollPane leftscrollPane, SetHTML htmlPane, HashSet<String> headerSubheaderNames, boolean filtered) {
		this.Root = Root;
		this.treeModel = treeModel;
		this.tree = tree;
		this.leftscrollPane = leftscrollPane;
		this.htmlPane = htmlPane;
		this.headerSubheaderNames = headerSubheaderNames;
		this.filtered = filtered;
	}
	
	/**
	 * This method is derived from the tree widget of Oliver Watkins.
	 * http://blue-walrus.com/2011/03/swing-filtered-tree-just-like-in-eclipse/
	 * ------------------------------------------------------------------------------------
	 * 
	 * Tree widget which allows the tree to be filtered on keystroke time. Only nodes who's
	 * toString matches the search field will remain in the tree or its parents.
	 *
	 * Copyright (c) Oliver.Watkins
	 */
	public void filterTree(String text, JCheckBox searchAll) {
		String filteredText = text;
		DefaultMutableTreeNode filteredRoot = copyNode(Root);
		
		if(text.trim().toString().equals("")) {
			treeModel.setRoot(Root);
			tree.setModel(treeModel);

			tree.updateUI();
	
			leftscrollPane.getViewport().setView(tree);
			
			DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
			renderer.setLeafIcon(null);
			renderer.setClosedIcon(null);
			renderer.setOpenIcon(null);
			
			return;
		} else {
			HashMap<String, String> searchAllExamples = htmlPane.getSearchAllExamples();
			HashMap<String, String> searchAllDescriptions = htmlPane.getSearchAllDescriptions();
			HashMap<String, String> savedHTML = htmlPane.getSavedHTML();
			
			TreeNodeBuilder b = new TreeNodeBuilder(text, savedHTML, headerSubheaderNames, searchAllExamples, searchAllDescriptions);
			
			filteredRoot = b.prune((DefaultMutableTreeNode) filteredRoot.getRoot(), searchAll.isSelected());

			treeModel.setRoot(filteredRoot);
			
			tree.setModel(treeModel);

			tree.updateUI();
	
			leftscrollPane.getViewport().setView(tree);	

		}
		
		for(int i = 0; i<tree.getRowCount(); i++) {
			tree.expandRow(i);
		}
		
		DefaultTreeCellRenderer renderer = (DefaultTreeCellRenderer) tree.getCellRenderer();
		renderer.setLeafIcon(null);
		renderer.setClosedIcon(null);
		renderer.setOpenIcon(null);
	
		filtered = true;
	}
	
	private DefaultMutableTreeNode copyNode(DefaultMutableTreeNode orig) {
		DefaultMutableTreeNode newOne = new DefaultMutableTreeNode();
		newOne.setUserObject(orig.getUserObject());
		Enumeration enm = orig.children();
		
		while(enm.hasMoreElements()) {
			DefaultMutableTreeNode child = (DefaultMutableTreeNode) enm.nextElement();
			newOne.add(copyNode(child));
		}
		
		return newOne;
	}
}
