
sample =

    c: """
#include <stdio.h>

/* Euclid */
int gcd (int a, int b) {
    while (a != b) {
        if (a > b) a -= b;
        else b -= a;
    }
    return a;
}

/* Main */
int main () {
    int x, y;
    scanf("%d %d", &x, &y);
    printf("%i\\n", gcd(x, y));
}
"""

    cc: """
#include <iostream>
using namespace std;

// Euclid
int gcd (int a, int b) {
    while (a != b) {
        if (a > b) a -= b;
        else b -= a;
    }
    return a;
}

// Main
int main () {
    int x, y;
    cin >> x >> y;
    cout << gcd(x, y) << endl;
}
"""

    js: """
// Euclid
function gcd (a, b) {
    while (a != b) {
        if (a > b) a -= b;
        else b -= a;
    }
    return a;
}

"""

    py: """
# Euclid
def gcd (a, b):
    while a != b:
        if a > b: a -= b
        else: b -= a;
    return a;

# main
x = raw_input()
y = raw_input()
print(gcd(x,y))
"""

    rb: """
# Euclid, fast
def gcd (u, v)
  while v > 0
    u, v = v, u % v
  end
  u
end
"""


window.start_index = ->

    $(document).ready ->

        editor = ace.edit 'editor'

        editor.getSession().setMode 'ace/mode/c_cpp'
        #editor.setTheme 'ace/theme/monokai'
        editor.setShowPrintMargin false
        editor.renderer.setShowGutter true
        editor.getSession().setUseWrapMode false
        editor.setOptions
            minLines: 21
            maxLines: 21
            fontSize: '12pt'
            highlightActiveLine: false
        editor.setValue sample.cc, -1
        editor.setValue sample.cc, 1


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


window.set_sample = ->

    editor = ace.edit 'editor'
    lang = $('#lang').val()
    editor.setValue sample[lang], -1
    editor.setValue sample[lang], 1

