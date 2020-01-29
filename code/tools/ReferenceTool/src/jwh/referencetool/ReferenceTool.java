/**
 * A built-in reference Tool for the PDE.
 *
 * Copyright (c) 2018 Jae Won Hyun
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 *
 * @author   Jae Hyun
 * @modified August 3rd, 2018
 * @version  1.0.0
 */

package jwh.referencetool;

import processing.app.Base;
import processing.app.tools.Tool;
import processing.app.ui.Editor;

public class ReferenceTool implements Tool {
  Base base;
  static SplitPane newpane;


  public String getMenuTitle() {
    return "Reference Tool";
  }


  public void init(Base base) {
    // Store a reference to the Processing application itself
    this.base = base;
  }


  public void run() {
    // Get the currently active Editor to run the Tool on it
	  Editor editor = base.getActiveEditor();
	  try {
	  	if(newpane == null) {
	  		newpane = new SplitPane(base);
	    		System.out.println("Reference Tool 1.1.1 by Jae Hyun");
	  	}
	  	newpane.pack();
	    	newpane.setVisible(true);
	  } catch (Exception e) {
	    	e.printStackTrace();
	  }
  }
}
