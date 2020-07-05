import "./styles.scss";
console.log("hello mars!");

const url = './nes_fg.nes';

const load_binary_resource = (url) => {
    var req = new XMLHttpRequest();
    req.open('GET', url, false);
    //XHR binary charset opt by Marcus Granado 2006 [http://mgran.blogspot.com]
    req.overrideMimeType('text\/plain; charset=x-user-defined');
    req.send(null);

    console.log(req)

    if (req.status != 200) return '';
    return req.responseText;
  }


  
console.log(load_binary_resource(url));


const emuNES = new jsnes.NES({
    onFrame: function(frameBuffer) {
      // ... write frameBuffer to screen
    },
    onAudioSample: function(left, right) {
      // ... play audio sample
    }
  });

  emuNES.