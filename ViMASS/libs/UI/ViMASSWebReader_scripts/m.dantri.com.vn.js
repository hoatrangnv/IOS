String.trim = function ()
{
    return this.replace(/$[\s\n\r\t]+/g, '').replace(/^[\s\r\n\t]/g, '');
}

function vimass_reader()
{
    var title = null;
    var time = null;
    var review = null;
    var detail = null;
    var author = '';
    var source = 'dantri.com.vn';
    
    var content = document.getElementById('content');
    
    // Parse title
    var xp = document.evaluate("*/font[1]/b[1]", content, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
    title = xp.snapshotItem(0).innerHTML;
    
    // Parse post time
    xp = document.evaluate("div/div[1]/span[1]", content, null, XPathResult.STRING_TYPE, null);
    time = xp.stringValue.trim();
    
    // Parse review
    xp = document.evaluate("div[1]/span[1]", content, null, XPathResult.STRING_TYPE, null);
    review = xp.stringValue.trim();
    
    // Parse detail
    var o = document.getElementsByClassName('news_details')[0];
    
    return {'title': title, 'time': time, 'review' : review, 'detail': o.innerHTML,'author':author,'source':source};
}