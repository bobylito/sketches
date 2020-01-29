package jwh.referencetool;

import javax.swing.text.html.HTMLEditorKit;
import javax.swing.text.html.HTML;
import javax.swing.text.*;

/**
 * Fixing the <pre> tag of html to stay in its cell without having to resize the frame
 * ---------------------------------------------------------------------------------------
 * https://stackoverflow.com/questions/3788624/pre-wrap-in-a-jeditorpane
 * @author Braulio Horta
 */

public class PreWrapHTMLEditorKit extends HTMLEditorKit{
	ViewFactory viewFactory = new HTMLFactory() {

        @Override
        public View create(Element elem) {
            AttributeSet attrs = elem.getAttributes();
            Object elementName = attrs.getAttribute(AbstractDocument.ElementNameAttribute);
            Object o = (elementName != null) ? null : attrs.getAttribute(StyleConstants.NameAttribute);
            if (o instanceof HTML.Tag) {
                HTML.Tag kind = (HTML.Tag) o;
                if (kind == HTML.Tag.IMPLIED) {
                    return new javax.swing.text.html.ParagraphView(elem);
                }
            }
            return super.create(elem);
        }
    };

    @Override
    public ViewFactory getViewFactory() {
        return this.viewFactory;
    }
}
