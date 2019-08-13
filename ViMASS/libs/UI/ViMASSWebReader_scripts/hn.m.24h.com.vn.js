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
    var author = null;
    var source = '24h.com.vn';
    
    var content = document.getElementsByClassName('tin-anh')[0];
    
    var elements = null;
    // parse post time
    elements = document.getElementsByClassName('bv-date');
    if(elements.length > 0)
        time = elements[0].innerHTML.trim();
    else
        time = '';
    
    // parse title
    elements = document.getElementsByClassName('bv-tieude');
    if(elements.length > 0)
        title = elements[0].innerHTML.trim();
    else
        title = '';
    
    // parst review
    elements = document.getElementsByClassName('bv-content');
    if(elements.length > 0)
    {
        var bv_content = elements[0];
        var bv_content_strong = bv_content.getElementsByTagName('strong');
        if(bv_content_strong.length > 0)
        {
            review = bv_content_strong[0].innerHTML;
        }else{
            review = bv_content.innerHTML;
        }
        review = review.trim();
    }else
    {
        review = '';
    }

    /* 
     * Parse detail
     */
    // remove img-thumb
    elements = document.getElementsByClassName('img-thumb');
    if(elements.length > 0)
        content.removeChild(elements[0].parentNode);
    
    // remove bv-tieude
    elements = document.getElementsByClassName('bv-tieude');
    if(elements.length > 0)
        content.removeChild(elements[0].parentNode);
    
    // remove bv-date
    elements = document.getElementsByClassName('bv-date');
    if(elements.length > 0)
        content.removeChild(elements[0]);
    
    // remove bv-content
    elements = document.getElementsByClassName('bv-content');
    if(elements.length > 0)
        content.removeChild(elements[0]);
    
    // parse author
    var divs = document.getElementsByTagName('div');
    var link_top_content = document.getElementsByClassName('link-top-content')[0];
    var e_author = null;
    for(var i = 0;i< divs.length;i++)
    {
        var div = divs[i];
        if(div == link_top_content)
        {
            e_author = divs[i+1];
            break;
        }
    }
    author = e_author != null ? e_author.innerHTML : '';
    
    return {'title': title, 'time': time, 'review' : review, 'detail': content.innerHTML,'author':author,'source':source};
}