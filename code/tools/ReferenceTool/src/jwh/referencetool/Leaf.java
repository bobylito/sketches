package jwh.referencetool;

import java.util.ArrayList;
import javax.swing.tree.DefaultMutableTreeNode;

/*
 * 
 * Leaves are the references with the HTML files.
 * Some Leaves have more children for their methods and fields references.
 * 
 */
public class Leaf {
	DefaultMutableTreeNode leaf;
	DefaultMutableTreeNode methods = null;
	DefaultMutableTreeNode fields = null;
	ArrayList<DefaultMutableTreeNode> leafMethods = new ArrayList<DefaultMutableTreeNode>();
	ArrayList<DefaultMutableTreeNode> leafFields = new ArrayList<DefaultMutableTreeNode>();
	
	public Leaf(String leafInput) {
		if(leafInput.indexOf('`') >= 0) {
			methods = new DefaultMutableTreeNode("Methods");
			fields = new DefaultMutableTreeNode("Fields");
		
			leafInput = leafInput.replace("`", "");
		} 
		
		leaf = new DefaultMutableTreeNode(leafInput);
	}
	
	public void addLeafMethods(ArrayList<DefaultMutableTreeNode> inputlist) {
		methods = new DefaultMutableTreeNode("Methods");
		for(DefaultMutableTreeNode leafMethod : inputlist) {
			leafMethods.add(leafMethod);
		}
		
		for(DefaultMutableTreeNode method : leafMethods) {
			methods.add(method);
		}
		
		leaf.add(methods);
	}
	
	public void addLeafFields(ArrayList<DefaultMutableTreeNode> inputlist) {
		fields = new DefaultMutableTreeNode("Fields");
		
		for(DefaultMutableTreeNode leafField : inputlist) {
			leafFields.add(leafField);
		}
		
		for(DefaultMutableTreeNode field : leafFields) {
			fields.add(field);
		}
		
		leaf.add(fields);
	}
	
	public DefaultMutableTreeNode getLeaf() {
		return leaf;
	}
}
