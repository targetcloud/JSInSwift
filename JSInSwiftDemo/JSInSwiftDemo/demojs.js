window.onload = function(){
    var allImg = document.getElementsByTagName("img");
    for(var i=0; i<allImg.length; i++){
        var img = allImg[i];
        img.id = i;
        img.onclick = function(){
            window.location.href = 'tg:///openCamera'
        }
    }
    var img = document.createElement('img');
    img.style.cssText = "width:50%";
    img.src = 'https://avatars0.githubusercontent.com/u/22094559?v=3&s=460';
    document.body.appendChild(img);
}
