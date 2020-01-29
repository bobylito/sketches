package jwh.referencetool;

import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.*;
import java.io.*;
import java.net.URL;

public class RegEx {
	String theWholeThing = "";
	
	ArrayList<String> parameterNames = new ArrayList<String>();
	ArrayList<String> parameterDescs = new ArrayList<String>();
	ArrayList<String> exampleImages = new ArrayList<String>();
	ArrayList<String> exampleCodes = new ArrayList<String>();
	ArrayList<String> methodNames = new ArrayList<String>();
	ArrayList<String> methodDescs = new ArrayList<String>();
	ArrayList<String> fieldNames = new ArrayList<String>();
	ArrayList<String> fieldDescs = new ArrayList<String>();
	ArrayList<String> related = new ArrayList<String>();
	
	public RegEx(URL htmlName) {
		try {
			theWholeThing = readHTML(htmlName);
		} catch (IOException e) {
			e.printStackTrace();
		}
		String[] tokens = theWholeThing.split("<!-- ==================================== CONTENT - Headers ============================ -->");
		tokens = tokens[1].split("<!-- ==================================== FOOTER ============================ -->");
		String theWholeThing = tokens[0];
	}
	
	/*
	 * Reading in the html file
	 */
	private String readHTML(URL htmlName) throws IOException {
		BufferedReader in = new BufferedReader(new InputStreamReader(htmlName.openStream()));
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
	 * Parsing for Name of the reference
	 */
	public String parseName() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Name</th>\\s*<td><h3>(.+?(?=</h3>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		
		String name = "";
		if(matcher.find()) {
			name = matcher.group(1);
		}
		
		return name;
	}
	
	/*
	 * Parsing for Examples of the reference
	 */
	public void parseExamples() {
		//parse out entire block
		Pattern pattern = Pattern.compile("<tr class=\"\"><th scope=\"row\">Examples</th><td>([\\S\\s]+?(?=</td>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		
		if(matcher.find()) {
			String examplesBlock = matcher.group(1);
			
			// parse out individual examples
			pattern = Pattern.compile("<div class=\"example\"><img src=(.+?(?=alt=\"example pic\" />))");
			matcher = pattern.matcher(examplesBlock);
			
			while(matcher.find()) {
				String imageName = matcher.group(1);
				imageName = imageName.replaceAll("\"", "");
				exampleImages.add(imageName);
			}
			
			pattern = Pattern.compile("<pre.+?>\\n([\\S\\s]+?(?=</pre>))");
			matcher = pattern.matcher(examplesBlock);
			
			while(matcher.find()) {
				String codeExample = matcher.group(1);
				exampleCodes.add(matcher.group(1));
			}
		}
	}
	
	/*
	 * Parsing for Descriptions of the reference
	 */
	public String parseDescription() {
		Pattern pattern = Pattern.compile("<tr class=\"\">\\n*\\s*<th scope=\"row\">Description</th>\\n*\\s*<td>\\n*\\s*([\\S\\s]+?(?=\\n*</td>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		String description = "";
		
		if(matcher.find()) {
			description = matcher.group(1);
		}
		
		return description;
	}
	
	/*
	 * Parsing for Syntax of the reference
	 */
	public String parseSyntax() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Syntax</th><td><pre>([\\S\\s]+?(?=</pre>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		
		String syntax = "";
		
		if(matcher.find()) {
			syntax = matcher.group(1);
		}
		
		return syntax;
	}
	
	/*
	 * Parsing for Parameters of the reference
	 */
	public void parseParameters() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Parameters</th><td><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\">([\\S\\s]+?(?=</table>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		
		if(matcher.find()) {
			String paramsBlock = matcher.group(1);
			pattern = Pattern.compile("(?:<th scope=\"row\" class=\"code\">(.+?(?=</th>))</th>\\n*<td>(.+?(?=</td>))</td>)");
			matcher = pattern.matcher(paramsBlock);
			
			while(matcher.find()) {
				parameterNames.add(matcher.group(1));
				parameterDescs.add(matcher.group(2));
			}
		}
	}
	
	/*
	 * Parsing for Returns of the reference
	 */
	public String parseReturns() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Returns</th><td class=\"code\">(.+?(?=</td>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		String returns = "";
		if(matcher.find()) {
			returns = matcher.group(1);
		}
		
		return returns;
	}
	
	/*
	 * Parsing for Related of the reference
	 */
	public ArrayList<String> parseRelated() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Related</th><td>([\\S\\s]+?(?=</td>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		
		if(matcher.find()) {
			String relatedBlock = matcher.group(1);
			pattern = Pattern.compile("<a class=\"code\" .+>(.+?(?=</a>))");
			matcher = pattern.matcher(relatedBlock);
			
			if(matcher.find()) {
				related.add(matcher.group(1));
			}
		}
		
		return related;
	}
	
	/*
	 * Parsing for Constructor of the reference
	 */
	public String parseConstructor() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Constructor</th><td>([\\S\\s]+?(?=</td>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		String constructor = "";
		if(matcher.find()) {
			constructor = matcher.group(1);
		}
		
		return constructor;
	}
	
	/*
	 * Parsing for Methods of the reference
	 */
	public void parseMethods() {
		Pattern pattern = Pattern.compile("<th scope=\"row\">Methods</th><td><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr class=\"\">([\\S\\s]+?(?=</table>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		
		
		if(matcher.find()) {
			String methodsBlock = matcher.group(1);
			
			pattern = Pattern.compile("(?:\\n*\\t*<th scope=\"row\"><a href=.+>(.+?(?=</a>))</a></th>\\n*\\t*<td>(.+?(?=</td>)))");
			matcher = pattern.matcher(methodsBlock);
			
			while(matcher.find()) {
				methodNames.add(matcher.group(1));
				methodDescs.add(matcher.group(2));
			}
		}
	}
	
	/*
	 * Parsing for Fields of the reference
	 */
	public void parseFields() {
		Pattern pattern = Pattern.compile("<th scope=\"row\"><b>Fields</b></th><td><table cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr class=\"\">([\\S\\s]+?(?=</table>))");
		Matcher matcher = pattern.matcher(theWholeThing);
		String fieldsBlock = "";
		
		if(matcher.find()) {
			fieldsBlock = matcher.group(1);
			
			pattern = Pattern.compile("(?:\\n*\\t*<th scope=\"row\"><a href=.+>(.+?(?=</a>))</a></th>\\n*\\t*<td>(.+?(?=</td>)))");
			matcher = pattern.matcher(fieldsBlock);
			
			while(matcher.find()) {
				fieldNames.add(matcher.group(1));
				fieldDescs.add(matcher.group(2));
			}
		}
		
	}
	
	public ArrayList<String> getExampleImages() {
		return exampleImages;
	}
	
	public ArrayList<String> getExampleCodes() {
		return exampleCodes;
	}
	
	public ArrayList<String> getMethodNames() {
		return methodNames;
	}
	
	public ArrayList<String> getMethodDescs() {
		return methodDescs;
	}
	
	public ArrayList<String> getFieldNames() {
		return fieldNames;
	}
	
	public ArrayList<String> getFieldDescs() {
		return fieldDescs;
	}
	
	public ArrayList<String> getParameterNames() {
		return parameterNames;
	}
	
	public ArrayList<String> getParameterDescs() {
		return parameterDescs;
	}
	
}
