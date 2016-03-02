

window.start_index = ->

    $(document).ready ->

        sample = """
/* Sample code */

#include <iostream>
#include <vector>
using namespace std;

// euclid
int mcd (int a, int b) {
    while (a != b) {
        if (a > b) a = a - b;
        else b = b - a;
    }
    return a;
}

// main
int main () {
    cout << "Give me two numbers: ";
    int x, y;
    cin >> x >> y;
    int m = mcd(x, y);
    cout << "The mcd of " << x << " and " << y << " is " << m << endl;
    cout << mcd(x, y) << endl;
}
"""

        editor = ace.edit 'editor'

        editor.getSession().setMode 'ace/mode/c_cpp'
        #editor.setTheme 'ace/theme/monokai'
        editor.setShowPrintMargin false
        editor.renderer.setShowGutter true
        editor.getSession().setUseWrapMode false
        editor.setOptions
            minLines: 25
            maxLines: 25
            fontSize: '12pt'
            highlightActiveLine: false
        editor.setValue sample, -1
        editor.setValue sample, 1


        $editor = $('#editor')
        $editor.closest('form').submit ->
            console.log "subm"
            code = editor.getValue()
            $editor.prev('input[type=hidden]').val code



window.start_submission = ->

    $(document).ready ->
        hljs.initHighlightingOnLoad()



window.set_lang = ->

    modes =
        c: 'c_cpp'
        cc: 'c_cpp'
        js: 'javascript'
        py: 'python'
        rb: 'ruby'

    lang = $('#lang').val()
    editor = ace.edit 'editor'
    editor.getSession().setMode 'ace/mode/'+modes[lang]

