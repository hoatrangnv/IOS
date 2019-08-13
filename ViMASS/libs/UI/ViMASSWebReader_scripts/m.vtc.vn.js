function send_command ()
{
    window.location.href = "vimass://command";
    return;
    var req = new XMLHttpRequest();
    xmlhttp.open("GET","vimass://command",false);
    xmlhttp.send();
}

function start()
{
    try
    {
        parse_article();
    }catch(e)
    {
        alert(e);
        setTimeout (function()
        {
            start();
        }, 1000);
    }
    /*if (document.readyState === "complete")
    {
        alert('load roi');
        xxx();
        return;
    }
    alert('chua load');
    document.body.onload = xxx;*/
};

start();

function parse_article()
{
    var rslt;
    try
    {
        rslt = vimass_reader();
    }
    catch(e)
    {
//        alert(e);
        throw e;
        return;
    }
    
    document.body.innerHTML =
    '<div style="margin: 10px; text-align: justify;">' +
    '<p style="font-weight: bold; font-size: 14px;">' + rslt.title + '</p>' +
    '<div style="font-size:10px; color: #FF0000;">' + rslt.time + '</div>' +
    '<div style="font-weight: bold; font-size:12px; font-style:italic;">' + rslt.review + '</div>' +
    '<div style="margin-top: 5px; font-size: 14px;">' + rslt.detail + '</div>' +
    '<p style="text-align: right;color:blue;font-weight: bold; font-size: 14px;">' + rslt.source + '</p>' +
    '<p style="text-align: right;font-weight: bold; font-size: 14px;">' + rslt.author + '</p>' +
    '</div>';
    
    setTimeout (function()
    {
        send_command();
    }, 1000);
    
    
};