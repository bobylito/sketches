package jwh.referencetool;
import javax.swing.tree.DefaultMutableTreeNode;
import java.io.*;
import java.util.*;

/*
 * 
 * Subheaders are sections inside each category that have leaves as children
 * Headers may or may not have them.
 * 
 * This includes: 
 * 	 Data - Primitive, Composite, Conversion
 * 			String Functions, Array Functions
 * 	 Control - Relational Operators, Iteration
 * 			   Conditionals, Logical Operators
 * 	 Shape - 2D Primitives, Curves, 3D Primitives
 * 			 Attributes, Vertex, Loading and Displaying
 * 	 Input - Mouse, Keyboard, Files, Time & Date
 * 	 Output - Text Area, Images, Files
 *	 Lights, Camera - Lights, Camera, Coordinates,
 *					  Material Properties
 *	 Color - Setting, Creating & Reading
 *	 Image - Loading & Displaying, Textures, Pixels
 *	 Rendering - Shaders
 *	 Typography - Loading & Displaying, Attributes, Metrics
 *	 Math - Operators, Bitwise Operators, Calculation
 *			Trigonometry, Random, 
 *
 */
public class SubHeader {
	DefaultMutableTreeNode subHeader;
	ArrayList<Leaf> leaves = new ArrayList<Leaf>();
	
	public SubHeader(String subheaderInput) {
		subHeader = new DefaultMutableTreeNode(subheaderInput);
	}

	public void addLeaves(ArrayList<Leaf> inputlist) {
		for(Leaf currentleaf : inputlist) {
			leaves.add(currentleaf);
		}
		
		for(Leaf currentLeaf : leaves) {
			subHeader.add(currentLeaf.getLeaf());
		}
	}
	
	public DefaultMutableTreeNode getSubHeader() {
		return subHeader;
	}
}
