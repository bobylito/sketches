package jwh.referencetool;
import javax.swing.tree.DefaultMutableTreeNode;
import java.io.*;
import java.util.*;

/*
 * 
 * Headers are bolded categories on https://www.processing.org/reference/
 * This includes:
 * 	 Structure, Environment, Data
 * 	 Control, Shape, Input, Output
 * 	 Transform, Lights and Camera, 
 * 	 Color, Image, Rendering, 
 * 	 Typography, Math, Constants
 * 
 */
public class Header {
	DefaultMutableTreeNode header;
	int misc = 0;
	Integer numberofSubHeaders = 0;
	ArrayList<Leaf> leaves = new ArrayList<Leaf>();
	LinkedHashMap<SubHeader, Integer> subHeaderNumber = new LinkedHashMap<SubHeader, Integer>();
	
	public Header(String headerName) {
		header = new DefaultMutableTreeNode(headerName);
	}
	
	public void setMisc(int numInput) {
		misc = numInput;
	}
	
	public void setNumberofSubHeaders(Integer numInput) {
		numberofSubHeaders = numInput;
	}

	public void setSubHeaderNumber(LinkedHashMap<SubHeader, Integer> hashmapInput) {
		subHeaderNumber =  hashmapInput;
	}
	
	public int getMisc() {
		return misc;
	}
	
	public DefaultMutableTreeNode getHeader() {
		return header;
	}
	
	public Integer getNumberofSubHeaders() {
		return numberofSubHeaders;
	}
	
	public void addMiscLeaves(Leaf newleaf) {
		leaves.add(newleaf);
	}
	
	public void connectNodes() {
		for(Leaf currentleaf : leaves) {
			header.add(currentleaf.getLeaf());
		}
	}
	
	public LinkedHashMap<SubHeader, Integer> getSubHeaderNumber() {
		return subHeaderNumber;
	}
	
	public void addSubHeaders() {
		for(SubHeader subHeader : subHeaderNumber.keySet()) {
			header.add(subHeader.getSubHeader());
		}
	}
}
