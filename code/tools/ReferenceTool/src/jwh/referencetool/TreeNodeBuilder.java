package jwh.referencetool;

import javax.swing.tree.DefaultMutableTreeNode;
import java.util.*;
import java.io.*;

/**
 * This class uses an implementation of Oliver Watkins' TreeNodeBuilder.
 * 
 * Tree widget which allows the tree to be filtered on keystroke time. Only nodes who's
 * toString matches the search field will remain in the tree or its parents.
 *
 * Copyright (c) Oliver.Watkins
 */

/**
 * Class that prunes off all leaves which do not match the search string.
 *
 * @author Oliver.Watkins
 */

public class TreeNodeBuilder {
	private String textToMatch;
	HashSet<String> headerSubHeaderNames;
	HashMap<String, String> savedHTML;
	HashMap<String, String> searchAllDescriptions;
	HashMap<String, String> searchAllExamples;
	
	public TreeNodeBuilder(String textToMatch, HashMap<String, String> savedHTML, HashSet<String> headerSubHeaderNames, HashMap<String, String> searchAllExamples, HashMap<String, String> searchAllDescriptions) {
		this.savedHTML = savedHTML;
		this.headerSubHeaderNames = headerSubHeaderNames;
		this.textToMatch = textToMatch;
		this.searchAllExamples = searchAllExamples;
		this.searchAllDescriptions = searchAllDescriptions;
	}
	
	public DefaultMutableTreeNode prune(DefaultMutableTreeNode root, boolean searchAllSelected) {
		boolean badLeaves = true;
		
		while(badLeaves) {
			badLeaves = removeBadLeaves(root, searchAllSelected);
		}

		return root;
	}
	
	/*
	 * Removing leaves that does not fit the search criteria
	 */
	private boolean removeBadLeaves(DefaultMutableTreeNode root, boolean searchAllSelected) {
		boolean badLeaves = false;
		NodeNameGenerator gen = new NodeNameGenerator(headerSubHeaderNames);
		
		DefaultMutableTreeNode leaf = root.getFirstLeaf();
		
		if(leaf.isRoot())
			return false;
		
		int leafCount = root.getLeafCount();
		// if we are searching for all
		if(searchAllSelected) {
			// while going through all children of the root
			for(int i = 0; i < leafCount; i++) {
				DefaultMutableTreeNode nextLeaf = leaf.getNextLeaf();
				DefaultMutableTreeNode parent = (DefaultMutableTreeNode) leaf.getParent();
				
				// get the generated node name (basically the html file name without .html)
				String nodeName = gen.generator(leaf);
				String code = "";
				String description = "";
				
				if(searchAllExamples.containsKey(nodeName) || searchAllDescriptions.containsKey(nodeName)) {
					code = searchAllExamples.get(nodeName).toLowerCase();
					description = searchAllDescriptions.get(nodeName).toLowerCase();

					// basically if the node does not contain examples or descriptions that matches the seasrch
					if(!code.contains(textToMatch.toLowerCase()) && !description.contains(textToMatch.toLowerCase())) {
						
						//prune
						if(parent != null) {
							parent.remove(leaf);
						}
					
						badLeaves = true;
					}
					
				} else {
					// this leaves folders like methods, fields, headers....basically nodes that don't have html files
					if(!savedHTML.containsKey(nodeName)) {
						if(parent!= null) {
							parent.remove(leaf);
						}
						
						badLeaves = true;
					}
				}
				
				leaf = nextLeaf;
			}

		} else {
			for(int i = 0; i < leafCount; i++) {
				DefaultMutableTreeNode nextLeaf = leaf.getNextLeaf();
				DefaultMutableTreeNode parent = (DefaultMutableTreeNode) leaf.getParent();

				String parentstring = leaf.getParent().toString().toLowerCase();
				String gparentstring = "";
				String rootstring = root.toString().toLowerCase();
				if(leaf.getParent().getParent() != null) {
					gparentstring = leaf.getParent().getParent().toString().toLowerCase();
				}
				
				// if a node name begins with the text search
				// if a lower case of the node name begins with the lower case of the text search
				// if a lower case of the node name contains the lower case of the text search (is this redundant?)
				// if a parent lowercase contains the lower case text search
				// if a grandparent lowercase contains the lower case text search
				if(!leaf.getUserObject().toString().startsWith(textToMatch) 
						&& !leaf.getUserObject().toString().startsWith(textToMatch.toLowerCase())
						&& !leaf.getUserObject().toString().toLowerCase().contains(textToMatch.toLowerCase()) 
						&& !parentstring.contains(textToMatch.toLowerCase())
						&& !gparentstring.contains(textToMatch.toLowerCase())){
					
					
					if(parent != null) {
						parent.remove(leaf);
					}
					
					badLeaves = true;
				} else {
					String nodeName = gen.generator(leaf);
					
					// this leaves folders like methods, fields, headers....basically nodes that don't have html files
					if(!savedHTML.containsKey(nodeName)) {
						if(parent!= null) {
							parent.remove(leaf);
						}
						
						badLeaves = true;
					}
				}
				
				leaf = nextLeaf;
			}
		}

		return badLeaves;
	}
}