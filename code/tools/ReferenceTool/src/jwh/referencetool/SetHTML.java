package jwh.referencetool;

import javax.swing.JEditorPane;
import javax.swing.JButton;
import javax.swing.event.HyperlinkEvent;
import javax.swing.event.HyperlinkListener;
import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.StyleSheet;
import javax.swing.text.Document;
import javax.swing.text.Highlighter;
import javax.swing.text.DefaultHighlighter;
import javax.swing.text.BadLocationException;

import processing.app.Platform;
import processing.app.ui.Editor;

import java.awt.Color;
import java.awt.Desktop;
import java.io.*;
import java.net.URI;
import java.net.URL;
import java.util.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class SetHTML extends JEditorPane {
	HTMLEditorKit editorkit;
	StyleSheet css = new StyleSheet();
	String name = "";
	String returns = "";
	String description = "";
	String syntax = "";
	String constructor = "";

	ArrayList<String> parameterNames = new ArrayList<String>();
	ArrayList<String> parameterDescs = new ArrayList<String>();
	ArrayList<String> methodNames = new ArrayList<String>();
	ArrayList<String> methodDescs = new ArrayList<String>();
	ArrayList<String> fieldNames = new ArrayList<String>();
	ArrayList<String> fieldDescs = new ArrayList<String>();
	ArrayList<String> exampleImages = new ArrayList<String>();
	ArrayList<String> exampleCodes = new ArrayList<String>();
	
	HashMap<String, ArrayList<String>> mapofCodes = new HashMap<String, ArrayList<String>>();
	HashMap<String, String> searchAllDescriptions = new HashMap<String, String>();
	HashMap<String, String> searchAllExamples = new HashMap<String, String>();
	ArrayList<String> related = new ArrayList<String>();
	
	HashMap<String, String> savedHTML = new HashMap<String, String>();
	
	public SetHTML() {
		super.setContentType("text/html");
		editorkit = new PreWrapHTMLEditorKit();
		css = editorkit.getStyleSheet();
		setCSS();
		editorkit.setAutoFormSubmission(false);
		super.setEditorKit(editorkit);
		
		super.addHyperlinkListener(new HyperlinkListener() {
			@Override
			public void hyperlinkUpdate(HyperlinkEvent e) {
				if(e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) {
					handleLink(e.getURL().toExternalForm());
				}
			}
		});
	}
	
	public void setCSS() {
		css.addRule("body {font-family: ProcessingSansPro-Regular; font-size: 9px}");
		css.addRule(".sectionStyle {padding-top: 20px}");
		css.addRule(".widthStyle {width : 70px}");
		css.addRule(".sectionheaderStyle {width : 70px; valign: top}");
	}
	
	/*
	 * Reading through all Processing html files and saving them into a hashmap for later reference
	 */
	public void parseHTML(URL urlLink, String nodeName, boolean initiated, boolean searchAll, String searchText) {
		// after everything has been read in (initiated) and Search All has been chosen
		if(savedHTML.containsKey(nodeName) && initiated && searchAll && !searchText.equals("")) {
			String saved = savedHTML.get(nodeName);
			// filter for words that may cause weird color change
			if(searchText.equals("or")
					|| searchText.equals("for")
					|| searchText.equals("and")
					|| searchText.equals("is")
					|| searchText.equals("in")
					|| searchText.equals("me")
					|| searchText.equals("he")
					|| searchText.equals("she")
					|| searchText.equals("had")) {
				searchText = " " + searchText + " ";
			}
			
			// match for words that may have different upper + lower case combinations - arrayList, ArrayList, ARRAYLIST, arraylist
			String find = "((?i)"+searchText+")";
			Pattern pattern = Pattern.compile(find);
			Matcher matcher = pattern.matcher(saved);
			if(matcher.find()) {
				String found = matcher.group(1);
				// change font color to blue
				saved = saved.replace(matcher.group(1), "<font color=\"#db4730\">"+matcher.group(1)+"</font>");
			}
			
			this.setText(saved);
			// set scrollbar to the top
			this.setCaretPosition(0);
			
			
// 		will come back to this later - for now highlighter does not work even though it finds the right words
//			Highlighter.HighlightPainter painter = new DefaultHighlighter.DefaultHighlightPainter(Color.ORANGE);
//			int offset = saved.indexOf(searchText);
//			int length = searchText.length();
//			
//			while(offset != -1) {
//				try {
//					System.out.println(saved.substring(offset, offset+length));
//					this.getHighlighter().addHighlight(offset, offset+length, painter);
//					offset = saved.indexOf(searchText, offset + 1);
//				} catch (BadLocationException ble){
//					ble.printStackTrace();
//				}
//			}
		
		// already initiated and contains codeName but isn't for Search All	
		} else if(savedHTML.containsKey(nodeName) && initiated) {
			this.setText(savedHTML.get(nodeName));
			this.setCaretPosition(0);
			
		// for the very beginning when all the reference html files are being read in 
		} else {
			// make sure methods and fields aren't being parsed through regex
			if(!nodeName.equals("Methods") && !nodeName.equals("Fields")) {
				// set parsed strings
				RegEx regexer = new RegEx(urlLink);
				name = regexer.parseName();

				regexer.parseExamples();
				exampleImages = regexer.getExampleImages();
				exampleCodes = regexer.getExampleCodes();
				if(!mapofCodes.containsKey(nodeName)) {
					mapofCodes.put(nodeName, exampleCodes);
					StringBuilder sb = new StringBuilder();
					for(String code : exampleCodes) {
						sb.append(code);
						sb.append(" ");
					}
					searchAllExamples.put(nodeName, sb.toString());
				}
				
				description = regexer.parseDescription();
				
				if(!searchAllDescriptions.containsKey(nodeName)) {
					searchAllDescriptions.put(nodeName, description);
				}
				
				regexer.parseParameters();
				parameterNames = regexer.getParameterNames();
				parameterDescs = regexer.getParameterDescs();

				regexer.parseMethods();
				methodNames = regexer.getMethodNames();
				methodDescs = regexer.getMethodDescs();
				
				regexer.parseFields();
				fieldNames = regexer.getFieldNames();
				fieldDescs = regexer.getFieldDescs();
				
				syntax = regexer.parseSyntax();
				returns = regexer.parseReturns();
			
				constructor = regexer.parseConstructor();
				related = regexer.parseRelated();

				fillIn(nodeName);
			}
		}
	}
	
	public HashMap<String, ArrayList<String>> getMapofCodes() {
		return mapofCodes;
	}
	
	public HashMap<String, String> getSearchAllExamples() {
		return searchAllExamples;
	}
	
	public HashMap<String, String> getSearchAllDescriptions() {
		return searchAllDescriptions;
	}
	
	public HashMap<String, String> getSavedHTML() {
		return savedHTML;
	}
	
	/*
	 * Putting all html strings together and saving it in the hashmap for later reference
	 */
	private void fillIn(String nodeName) {
		String finalexampleString = exampleString();
		String descriptionString = descriptionString();
		String syntaxString = syntaxString();
		String parameterString = parameterString();
		String returnString = returnString();
		String relatedString = relatedString();
		String methodString = methodString();
		String fieldString = fieldString();
		String constructorString = constructorString();
		
		String namestring = "<table>"
				+ "<tr valign= \"top\">"
				+ "<td class=\"widthStyle\"><u>Name</u></td>"
				+ "<td><b>" + name + "</b></td>"
				+ "</tr>" 
				+ "</table>";
		
		String total = namestring + finalexampleString + descriptionString + fieldString + methodString + syntaxString + constructorString + parameterString + returnString + relatedString;
		total = total.replace("<<", "&lt;&lt;");
		total = total.replaceAll(" *< ", " &lt ");
		total = total.replaceAll(" *<= ", " &lt;= ");
		if(!savedHTML.containsKey(nodeName)) {
			savedHTML.put(nodeName, total);
		}
	}
	
	/*
	 * html string for Examples
	 */
	private String exampleString() {
		String hr = "<tr valign=\"top\"><td class=\"widthStyle\">&nbsp;</td><td><hr></td></tr>";
		String examples = "";
		String finalexampleString = "<table class=\"sectionStyle\">" 
				+ "<tr valign = \"top\"><td class=\"sectionheaderStyle\"><u>Examples</u></td>";
		ArrayList<String> nomoreImagesCode = new ArrayList<String>();
		boolean nomoreImages = false;
		
		if(exampleCodes.size() != 0) {
			for(int i = 0; i < exampleCodes.size(); i++) {
				String exampletr = "";

				if(i > 0) {
					exampletr = "<tr valign=\"top\"><td class=\"widthStyle\">&nbsp;</td>";
				}
				
				if(i >= exampleImages.size() && exampleImages.size() != 0)
					nomoreImages = true;
				
				String imageLocation = "";
				if(exampleImages.size() != 0 && nomoreImages == false) {
					imageLocation = exampleImages.get(i).trim();
					String testString = "modes/java/reference/"+imageLocation;
					File imagefile = Platform.getContentFile(testString);
					testString = imagefile.toURI().toString();
					imageLocation = "<td><img src=\""+testString+"\"></td><td width = 10px>&nbsp;</td>";
				}
				
				String code = "";
				String returnCode = "";
				returnCode = exampleCodes.get(i).trim();
				
				// trying to syntax highlight for comments 
				String codeLines[] = returnCode.split("\\r?\\n");
				for(int j = 0; j < codeLines.length; j++) {
					if(codeLines[j].contains("//") 
							&& !codeLines[j].contains("https://") 
							&& !codeLines[j].contains("http://")) {
						codeLines[j] = codeLines[j].replace("//", "<span style=\"color: #5a7aad\">//");
						if(codeLines[j].contains(";") && !codeLines[j].contains("&lt;")) {
							codeLines[j] = codeLines[j].replaceAll(";", ";</span>");
						}
						
						codeLines[j] = codeLines[j] + "</span>";
					} 
					
					if(codeLines[j].contains("/*")) {
						codeLines[j] = codeLines[j].replace("/*", "<span style=\"color: #5a7aad\">/*");
					}
					
					if(codeLines[j].contains("*/")) {
						codeLines[j] = codeLines[j].replace("*/", "*/</span>");
					}
					
					code = code + codeLines[j] + "<br>";
				}

				code = "<td valign = \"top\"><pre >"+ code + "</pre></td></tr>";
				if(nomoreImages == true) {
					nomoreImagesCode.add(exampletr + code);
					code = "";
				}
			
				if(i < (exampleCodes.size()-1) && imageLocation.equals("")) {
					code = code + hr;
				}
				
				if(!imageLocation.equals("")) {
					finalexampleString = finalexampleString + exampletr + imageLocation+code;
				} else {
					finalexampleString = finalexampleString + exampletr + code;
				}
			}
			
			if(nomoreImages == false) {
				finalexampleString = finalexampleString + "</table>";
			} else {
				// if examples contain images only for some 
				String allcode = "";
				for(int i = 0; i < nomoreImagesCode.size(); i++) {
					allcode = allcode + nomoreImagesCode.get(i);
				}
				
				allcode = "<table padding-top=\"0\" margin=\"0\">" + allcode + "</table>";
				
				finalexampleString = finalexampleString + "</table>" + allcode;
			}
			
		} else {
			finalexampleString = "";
		}

		return finalexampleString;
	}
	
	/*
	 * html string for Description
	 */
	private String descriptionString() {
		String descriptionstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Description</u></td><td>";
		
		descriptionstring = descriptionstring + description + "</td></tr></table>";
		
		return descriptionstring;
	}
	
	/*
	 * html string for Syntax
	 */
	private String syntaxString() {
		String syntaxstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Syntax</u></td><pre >";
		
		if(!syntax.equals("")) {
			syntax = syntax.trim().replaceAll("\\n", "<br>");
			
			syntaxstring = syntaxstring + syntax + "</pre></td></tr></table>";
	
		} else {
			syntaxstring = "";
		}
		
		return syntaxstring;
	}
	
	/*
	 * html string for Constructor
	 */
	private String constructorString() {
		String constructorstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Constructor</u></td>";
		
		if(!constructor.equals("")) {
			constructorstring = constructorstring + constructor + "</td></tr></table>";
		} else {
			constructorstring = "";
		}
		
		return constructorstring;
		
	}
	
	/*
	 * html string for Parameters
	 */
	private String parameterString() {
		String parameterstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Parameters</u></td>";
		String finalparamstring = "";
		if(parameterNames.size() != 0) {
			for(int i = 0; i < parameterNames.size(); i++) {
				String addon = "";
				if(i > 0) {
					addon = "<td class=\"widthStyle\">&nbsp;</td>";
				}
				
				String name = parameterNames.get(i);
				name = "<td class = \"widthStyle\"><b>"+name+"</b></td>";
				String description = "<td>"+parameterDescs.get(i)+"</td></tr>";
				
				finalparamstring = finalparamstring + addon + name + description;
			}
			
			finalparamstring = parameterstring + finalparamstring + "</table>";
		}
		
		return finalparamstring;
	}
	
	/*
	 * html string for Returns
	 */
	private String returnString() {
		String returnstring = "";
		if(!returns.equals("")) {
			returnstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Returns</u></td><td>"+returns+"</td></tr></table>";
		}

		return returnstring;
	}
	
	/*
	 * html string for Relatd
	 */
	private String relatedString() {
		String relatedstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Related</u></td>";
		String finalrelatedstring = "";
		
		if(related.size() != 0) {
			for(int i = 0; i < related.size(); i++) {
				String addon = "";
				if(i > 0) {
					addon = "<td class=\"widthStyle\">&nbsp;</td>";
				}
				
				String relatedName = related.get(i);
				relatedName = "<td class = \"widthStyle\">" + relatedName + "</td></tr>";
				
				finalrelatedstring = finalrelatedstring + addon + relatedName;
			}
			
			finalrelatedstring = relatedstring + finalrelatedstring + "</table>";
		}
		
		return finalrelatedstring;
	}
	
	/*
	 *  html string for Methods
	 */
	private String methodString() {
		String methodstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Methods</u></td>";
		String finalmethodstring = "";
		if(methodNames.size() != 0) {
			for(int i = 0; i < methodNames.size(); i++) {
				String addon = "";
				if(i > 0) {
					addon = "<td class=\"widthStyle\">&nbsp;</td>";
				}
				
				String name = methodNames.get(i);
				name = "<td class = \"widthStyle\"><b>"+name+"</b></td>";
				String description = "<td>"+methodDescs.get(i)+"</td></tr>";
				
				finalmethodstring = finalmethodstring + addon + name + description;
			}
			
			finalmethodstring = methodstring + finalmethodstring + "</table>";
		}
	
		return finalmethodstring;
	}
	
	/*
	 * html string for Fields
	 */
	private String fieldString() {
		String fieldstring = "<table class=\"sectionStyle\"><tr valign=\"top\"><td class=\"widthStyle\"><u>Fields</u></td>";
		String finalfieldstring = "";
		if(fieldNames.size() != 0) {
			for(int i = 0; i < fieldNames.size(); i++) {
				String addon = "";
				if(i > 0) {
					addon = "<td class=\"widthStyle\">&nbsp;</td>";
				}
				
				String name = fieldNames.get(i);
				name = "<td class = \"widthStyle\"><b>"+name+"</b></td>";
				String description = "<td>"+fieldDescs.get(i)+"</td></tr>";
				
				finalfieldstring = finalfieldstring + addon + name + description;
			}
			
			finalfieldstring = fieldstring + finalfieldstring + "</table>";
		}
		
		return finalfieldstring;
	}
	
	/*
	 * handling hyperlink
	 */
	private void handleLink(String link){
		try {
			openthislink(link);
		} catch(Exception e) {
			 e.printStackTrace();
		}
	}
	
	private void openthislink(String url) throws Exception {
		Desktop.getDesktop().browse(new URI(url));
	}
}