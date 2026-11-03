(function () {
    function q(s) { return '"' + String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"').replace(/\r/g, '\\r').replace(/\n/g, '\\n').replace(/\t/g, '\\t') + '"'; }
    var out = [], i, d;
    for (i = 0; i < app.documents.length; i++) {
        d = app.documents[i];
        out.push('{"name":' + q(d.name) + ',"saved":' + (d.saved ? 'true' : 'false') + '}');
    }
    return '[' + out.join(',') + ']';
}());
