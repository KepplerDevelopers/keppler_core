!function(t,e){"object"==typeof exports&&"object"==typeof module?module.exports=e():"function"==typeof define&&define.amd?define([],e):"object"==typeof exports?exports.ActiveStorage=e():t.ActiveStorage=e()}(this,function(){return function(t){function e(n){if(r[n])return r[n].exports;var i=r[n]={i:n,l:!1,exports:{}};return t[n].call(i.exports,i,i.exports,e),i.l=!0,i.exports}var r={};return e.m=t,e.c=r,e.d=function(t,r,n){e.o(t,r)||Object.defineProperty(t,r,{configurable:!1,enumerable:!0,get:n})},e.n=function(t){var r=t&&t.__esModule?function(){return t.default}:function(){return t};return e.d(r,"a",r),r},e.o=function(t,e){return Object.prototype.hasOwnProperty.call(t,e)},e.p="",e(e.s=2)}([function(t,e,r){"use strict";function n(t){var e=a(document.head,'meta[name="'+t+'"]');if(e)return e.getAttribute("content")}function i(t,e){return"string"==typeof t&&(e=t,t=document),o(t.querySelectorAll(e))}function a(t,e){return"string"==typeof t&&(e=t,t=document),t.querySelector(e)}function u(t,e){var r=arguments.length>2&&void 0!==arguments[2]?arguments[2]:{},n=t.disabled,i=r.bubbles,a=r.cancelable,u=r.detail,o=document.createEvent("Event");o.initEvent(e,i||!0,a||!0),o.detail=u||{};try{t.disabled=!1,t.dispatchEvent(o)}finally{t.disabled=n}return o}function o(t){return Array.isArray(t)?t:Array.from?Array.from(t):[].slice.call(t)}e.d=n,e.c=i,e.b=a,e.a=u,e.e=o},function(t,e,r){"use strict";function n(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}function i(t,e){if(t&&"function"==typeof t[e]){for(var r=arguments.length,n=Array(r>2?r-2:0),i=2;i<r;i++)n[i-2]=arguments[i];return t[e].apply(t,n)}}r.d(e,"a",function(){return c});var a=r(6),u=r(8),o=r(9),s=function(){function t(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}return function(e,r,n){return r&&t(e.prototype,r),n&&t(e,n),e}}(),f=0,c=function(){function t(e,r,i){n(this,t),this.id=++f,this.file=e,this.url=r,this.delegate=i}return s(t,[{key:"create",value:function(t){var e=this;a.a.create(this.file,function(r,n){if(r)return void t(r);var a=new u.a(e.file,n,e.url);i(e.delegate,"directUploadWillCreateBlobWithXHR",a.xhr),a.create(function(r){if(r)t(r);else{var n=new o.a(a);i(e.delegate,"directUploadWillStoreFileWithXHR",n.xhr),n.create(function(e){e?t(e):t(null,a.toJSON())})}})})}}]),t}()},function(t,e,r){"use strict";function n(){window.ActiveStorage&&Object(i.a)()}Object.defineProperty(e,"__esModule",{value:!0});var i=r(3),a=r(1);r.d(e,"start",function(){return i.a}),r.d(e,"DirectUpload",function(){return a.a}),setTimeout(n,1)},function(t,e,r){"use strict";function n(){d||(d=!0,document.addEventListener("submit",i),document.addEventListener("ajax:before",a))}function i(t){u(t)}function a(t){"FORM"==t.target.tagName&&u(t)}function u(t){var e=t.target;if(e.hasAttribute(l))return void t.preventDefault();var r=new c.a(e),n=r.inputs;n.length&&(t.preventDefault(),e.setAttribute(l,""),n.forEach(s),r.start(function(t){e.removeAttribute(l),t?n.forEach(f):o(e)}))}function o(t){var e=Object(h.b)(t,"input[type=submit]");if(e){var r=e,n=r.disabled;e.disabled=!1,e.focus(),e.click(),e.disabled=n}else e=document.createElement("input"),e.type="submit",e.style.display="none",t.appendChild(e),e.click(),t.removeChild(e)}function s(t){t.disabled=!0}function f(t){t.disabled=!1}e.a=n;var c=r(4),h=r(0),l="data-direct-uploads-processing",d=!1},function(t,e,r){"use strict";function n(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}r.d(e,"a",function(){return s});var i=r(5),a=r(0),u=function(){function t(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}return function(e,r,n){return r&&t(e.prototype,r),n&&t(e,n),e}}(),o="input[type=file][data-direct-upload-url]:not([disabled])",s=function(){function t(e){n(this,t),this.form=e,this.inputs=Object(a.c)(e,o).filter(function(t){return t.files.length})}return u(t,[{key:"start",value:function(t){var e=this,r=this.createDirectUploadControllers();this.dispatch("start"),function n(){var i=r.shift();i?i.start(function(r){r?(t(r),e.dispatch("end")):n()}):(t(),e.dispatch("end"))}()}},{key:"createDirectUploadControllers",value:function(){var t=[];return this.inputs.forEach(function(e){Object(a.e)(e.files).forEach(function(r){var n=new i.a(e,r);t.push(n)})}),t}},{key:"dispatch",value:function(t){var e=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};return Object(a.a)(this.form,"direct-uploads:"+t,{detail:e})}}]),t}()},function(t,e,r){"use strict";function n(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}r.d(e,"a",function(){return o});var i=r(1),a=r(0),u=function(){function t(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}return function(e,r,n){return r&&t(e.prototype,r),n&&t(e,n),e}}(),o=function(){function t(e,r){n(this,t),this.input=e,this.file=r,this.directUpload=new i.a(this.file,this.url,this),this.dispatch("initialize")}return u(t,[{key:"start",value:function(t){var e=this,r=document.createElement("input");r.type="hidden",r.name=this.input.name,this.input.insertAdjacentElement("beforebegin",r),this.dispatch("start"),this.directUpload.create(function(n,i){n?(r.parentNode.removeChild(r),e.dispatchError(n)):r.value=i.signed_id,e.dispatch("end"),t(n)})}},{key:"uploadRequestDidProgress",value:function(t){var e=t.loaded/t.total*100;e&&this.dispatch("progress",{progress:e})}},{key:"dispatch",value:function(t){var e=arguments.length>1&&void 0!==arguments[1]?arguments[1]:{};return e.file=this.file,e.id=this.directUpload.id,Object(a.a)(this.input,"direct-upload:"+t,{detail:e})}},{key:"dispatchError",value:function(t){this.dispatch("error",{error:t}).defaultPrevented||alert(t)}},{key:"directUploadWillCreateBlobWithXHR",value:function(t){this.dispatch("before-blob-request",{xhr:t})}},{key:"directUploadWillStoreFileWithXHR",value:function(t){var e=this;this.dispatch("before-storage-request",{xhr:t}),t.upload.addEventListener("progress",function(t){return e.uploadRequestDidProgress(t)})}},{key:"url",get:function(){return this.input.getAttribute("data-direct-upload-url")}}]),t}()},function(t,e,r){"use strict";function n(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}r.d(e,"a",function(){return s});var i=r(7),a=r.n(i),u=function(){function t(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}return function(e,r,n){return r&&t(e.prototype,r),n&&t(e,n),e}}(),o=File.prototype.slice||File.prototype.mozSlice||File.prototype.webkitSlice,s=function(){function t(e){n(this,t),this.file=e,this.chunkSize=2097152,this.chunkCount=Math.ceil(this.file.size/this.chunkSize),this.chunkIndex=0}return u(t,null,[{key:"create",value:function(e,r){new t(e).create(r)}}]),u(t,[{key:"create",value:function(t){var e=this;this.callback=t,this.md5Buffer=new a.a.ArrayBuffer,this.fileReader=new FileReader,this.fileReader.addEventListener("load",function(t){return e.fileReaderDidLoad(t)}),this.fileReader.addEventListener("error",function(t){return e.fileReaderDidError(t)}),this.readNextChunk()}},{key:"fileReaderDidLoad",value:function(t){if(this.md5Buffer.append(t.target.result),!this.readNextChunk()){var e=this.md5Buffer.end(!0),r=btoa(e);this.callback(null,r)}}},{key:"fileReaderDidError",value:function(t){this.callback("Error reading "+this.file.name)}},{key:"readNextChunk",value:function(){if(this.chunkIndex<this.chunkCount){var t=this.chunkIndex*this.chunkSize,e=Math.min(t+this.chunkSize,this.file.size),r=o.call(this.file,t,e);return this.fileReader.readAsArrayBuffer(r),this.chunkIndex++,!0}return!1}}]),t}()},function(t,e,r){!function(e){t.exports=e()}(function(t){"use strict";function e(t,e){var r=t[0],n=t[1],i=t[2],a=t[3];r+=(n&i|~n&a)+e[0]-680876936|0,r=(r<<7|r>>>25)+n|0,a+=(r&n|~r&i)+e[1]-389564586|0,a=(a<<12|a>>>20)+r|0,i+=(a&r|~a&n)+e[2]+606105819|0,i=(i<<17|i>>>15)+a|0,n+=(i&a|~i&r)+e[3]-1044525330|0,n=(n<<22|n>>>10)+i|0,r+=(n&i|~n&a)+e[4]-176418897|0,r=(r<<7|r>>>25)+n|0,a+=(r&n|~r&i)+e[5]+1200080426|0,a=(a<<12|a>>>20)+r|0,i+=(a&r|~a&n)+e[6]-1473231341|0,i=(i<<17|i>>>15)+a|0,n+=(i&a|~i&r)+e[7]-45705983|0,n=(n<<22|n>>>10)+i|0,r+=(n&i|~n&a)+e[8]+1770035416|0,r=(r<<7|r>>>25)+n|0,a+=(r&n|~r&i)+e[9]-1958414417|0,a=(a<<12|a>>>20)+r|0,i+=(a&r|~a&n)+e[10]-42063|0,i=(i<<17|i>>>15)+a|0,n+=(i&a|~i&r)+e[11]-1990404162|0,n=(n<<22|n>>>10)+i|0,r+=(n&i|~n&a)+e[12]+1804603682|0,r=(r<<7|r>>>25)+n|0,a+=(r&n|~r&i)+e[13]-40341101|0,a=(a<<12|a>>>20)+r|0,i+=(a&r|~a&n)+e[14]-1502002290|0,i=(i<<17|i>>>15)+a|0,n+=(i&a|~i&r)+e[15]+1236535329|0,n=(n<<22|n>>>10)+i|0,r+=(n&a|i&~a)+e[1]-165796510|0,r=(r<<5|r>>>27)+n|0,a+=(r&i|n&~i)+e[6]-1069501632|0,a=(a<<9|a>>>23)+r|0,i+=(a&n|r&~n)+e[11]+643717713|0,i=(i<<14|i>>>18)+a|0,n+=(i&r|a&~r)+e[0]-373897302|0,n=(n<<20|n>>>12)+i|0,r+=(n&a|i&~a)+e[5]-701558691|0,r=(r<<5|r>>>27)+n|0,a+=(r&i|n&~i)+e[10]+38016083|0,a=(a<<9|a>>>23)+r|0,i+=(a&n|r&~n)+e[15]-660478335|0,i=(i<<14|i>>>18)+a|0,n+=(i&r|a&~r)+e[4]-405537848|0,n=(n<<20|n>>>12)+i|0,r+=(n&a|i&~a)+e[9]+568446438|0,r=(r<<5|r>>>27)+n|0,a+=(r&i|n&~i)+e[14]-1019803690|0,a=(a<<9|a>>>23)+r|0,i+=(a&n|r&~n)+e[3]-187363961|0,i=(i<<14|i>>>18)+a|0,n+=(i&r|a&~r)+e[8]+1163531501|0,n=(n<<20|n>>>12)+i|0,r+=(n&a|i&~a)+e[13]-1444681467|0,r=(r<<5|r>>>27)+n|0,a+=(r&i|n&~i)+e[2]-51403784|0,a=(a<<9|a>>>23)+r|0,i+=(a&n|r&~n)+e[7]+1735328473|0,i=(i<<14|i>>>18)+a|0,n+=(i&r|a&~r)+e[12]-1926607734|0,n=(n<<20|n>>>12)+i|0,r+=(n^i^a)+e[5]-378558|0,r=(r<<4|r>>>28)+n|0,a+=(r^n^i)+e[8]-2022574463|0,a=(a<<11|a>>>21)+r|0,i+=(a^r^n)+e[11]+1839030562|0,i=(i<<16|i>>>16)+a|0,n+=(i^a^r)+e[14]-35309556|0,n=(n<<23|n>>>9)+i|0,r+=(n^i^a)+e[1]-1530992060|0,r=(r<<4|r>>>28)+n|0,a+=(r^n^i)+e[4]+1272893353|0,a=(a<<11|a>>>21)+r|0,i+=(a^r^n)+e[7]-155497632|0,i=(i<<16|i>>>16)+a|0,n+=(i^a^r)+e[10]-1094730640|0,n=(n<<23|n>>>9)+i|0,r+=(n^i^a)+e[13]+681279174|0,r=(r<<4|r>>>28)+n|0,a+=(r^n^i)+e[0]-358537222|0,a=(a<<11|a>>>21)+r|0,i+=(a^r^n)+e[3]-722521979|0,i=(i<<16|i>>>16)+a|0,n+=(i^a^r)+e[6]+76029189|0,n=(n<<23|n>>>9)+i|0,r+=(n^i^a)+e[9]-640364487|0,r=(r<<4|r>>>28)+n|0,a+=(r^n^i)+e[12]-421815835|0,a=(a<<11|a>>>21)+r|0,i+=(a^r^n)+e[15]+530742520|0,i=(i<<16|i>>>16)+a|0,n+=(i^a^r)+e[2]-995338651|0,n=(n<<23|n>>>9)+i|0,r+=(i^(n|~a))+e[0]-198630844|0,r=(r<<6|r>>>26)+n|0,a+=(n^(r|~i))+e[7]+1126891415|0,a=(a<<10|a>>>22)+r|0,i+=(r^(a|~n))+e[14]-1416354905|0,i=(i<<15|i>>>17)+a|0,n+=(a^(i|~r))+e[5]-57434055|0,n=(n<<21|n>>>11)+i|0,r+=(i^(n|~a))+e[12]+1700485571|0,r=(r<<6|r>>>26)+n|0,a+=(n^(r|~i))+e[3]-1894986606|0,a=(a<<10|a>>>22)+r|0,i+=(r^(a|~n))+e[10]-1051523|0,i=(i<<15|i>>>17)+a|0,n+=(a^(i|~r))+e[1]-2054922799|0,n=(n<<21|n>>>11)+i|0,r+=(i^(n|~a))+e[8]+1873313359|0,r=(r<<6|r>>>26)+n|0,a+=(n^(r|~i))+e[15]-30611744|0,a=(a<<10|a>>>22)+r|0,i+=(r^(a|~n))+e[6]-1560198380|0,i=(i<<15|i>>>17)+a|0,n+=(a^(i|~r))+e[13]+1309151649|0,n=(n<<21|n>>>11)+i|0,r+=(i^(n|~a))+e[4]-145523070|0,r=(r<<6|r>>>26)+n|0,a+=(n^(r|~i))+e[11]-1120210379|0,a=(a<<10|a>>>22)+r|0,i+=(r^(a|~n))+e[2]+718787259|0,i=(i<<15|i>>>17)+a|0,n+=(a^(i|~r))+e[9]-343485551|0,n=(n<<21|n>>>11)+i|0,t[0]=r+t[0]|0,t[1]=n+t[1]|0,t[2]=i+t[2]|0,t[3]=a+t[3]|0}function r(t){var e,r=[];for(e=0;e<64;e+=4)r[e>>2]=t.charCodeAt(e)+(t.charCodeAt(e+1)<<8)+(t.charCodeAt(e+2)<<16)+(t.charCodeAt(e+3)<<24);return r}function n(t){var e,r=[];for(e=0;e<64;e+=4)r[e>>2]=t[e]+(t[e+1]<<8)+(t[e+2]<<16)+(t[e+3]<<24);return r}function i(t){var n,i,a,u,o,s,f=t.length,c=[1732584193,-271733879,-1732584194,271733878];for(n=64;n<=f;n+=64)e(c,r(t.substring(n-64,n)));for(t=t.substring(n-64),i=t.length,a=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],n=0;n<i;n+=1)a[n>>2]|=t.charCodeAt(n)<<(n%4<<3);if(a[n>>2]|=128<<(n%4<<3),n>55)for(e(c,a),n=0;n<16;n+=1)a[n]=0;return u=8*f,u=u.toString(16).match(/(.*?)(.{0,8})$/),o=parseInt(u[2],16),s=parseInt(u[1],16)||0,a[14]=o,a[15]=s,e(c,a),c}function a(t){var r,i,a,u,o,s,f=t.length,c=[1732584193,-271733879,-1732584194,271733878];for(r=64;r<=f;r+=64)e(c,n(t.subarray(r-64,r)));for(t=r-64<f?t.subarray(r-64):new Uint8Array(0),i=t.length,a=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],r=0;r<i;r+=1)a[r>>2]|=t[r]<<(r%4<<3);if(a[r>>2]|=128<<(r%4<<3),r>55)for(e(c,a),r=0;r<16;r+=1)a[r]=0;return u=8*f,u=u.toString(16).match(/(.*?)(.{0,8})$/),o=parseInt(u[2],16),s=parseInt(u[1],16)||0,a[14]=o,a[15]=s,e(c,a),c}function u(t){var e,r="";for(e=0;e<4;e+=1)r+=p[t>>8*e+4&15]+p[t>>8*e&15];return r}function o(t){var e;for(e=0;e<t.length;e+=1)t[e]=u(t[e]);return t.join("")}function s(t){return/[\u0080-\uFFFF]/.test(t)&&(t=unescape(encodeURIComponent(t))),t}function f(t,e){var r,n=t.length,i=new ArrayBuffer(n),a=new Uint8Array(i);for(r=0;r<n;r+=1)a[r]=t.charCodeAt(r);return e?a:i}function c(t){return String.fromCharCode.apply(null,new Uint8Array(t))}function h(t,e,r){var n=new Uint8Array(t.byteLength+e.byteLength);return n.set(new Uint8Array(t)),n.set(new Uint8Array(e),t.byteLength),r?n:n.buffer}function l(t){var e,r=[],n=t.length;for(e=0;e<n-1;e+=2)r.push(parseInt(t.substr(e,2),16));return String.fromCharCode.apply(String,r)}function d(){this.reset()}var p=["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];return"5d41402abc4b2a76b9719d911017c592"!==o(i("hello"))&&function(t,e){var r=(65535&t)+(65535&e);return(t>>16)+(e>>16)+(r>>16)<<16|65535&r},"undefined"==typeof ArrayBuffer||ArrayBuffer.prototype.slice||function(){function e(t,e){return t=0|t||0,t<0?Math.max(t+e,0):Math.min(t,e)}ArrayBuffer.prototype.slice=function(r,n){var i,a,u,o,s=this.byteLength,f=e(r,s),c=s;return n!==t&&(c=e(n,s)),f>c?new ArrayBuffer(0):(i=c-f,a=new ArrayBuffer(i),u=new Uint8Array(a),o=new Uint8Array(this,f,i),u.set(o),a)}}(),d.prototype.append=function(t){return this.appendBinary(s(t)),this},d.prototype.appendBinary=function(t){this._buff+=t,this._length+=t.length;var n,i=this._buff.length;for(n=64;n<=i;n+=64)e(this._hash,r(this._buff.substring(n-64,n)));return this._buff=this._buff.substring(n-64),this},d.prototype.end=function(t){var e,r,n=this._buff,i=n.length,a=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];for(e=0;e<i;e+=1)a[e>>2]|=n.charCodeAt(e)<<(e%4<<3);return this._finish(a,i),r=o(this._hash),t&&(r=l(r)),this.reset(),r},d.prototype.reset=function(){return this._buff="",this._length=0,this._hash=[1732584193,-271733879,-1732584194,271733878],this},d.prototype.getState=function(){return{buff:this._buff,length:this._length,hash:this._hash}},d.prototype.setState=function(t){return this._buff=t.buff,this._length=t.length,this._hash=t.hash,this},d.prototype.destroy=function(){delete this._hash,delete this._buff,delete this._length},d.prototype._finish=function(t,r){var n,i,a,u=r;if(t[u>>2]|=128<<(u%4<<3),u>55)for(e(this._hash,t),u=0;u<16;u+=1)t[u]=0;n=8*this._length,n=n.toString(16).match(/(.*?)(.{0,8})$/),i=parseInt(n[2],16),a=parseInt(n[1],16)||0,t[14]=i,t[15]=a,e(this._hash,t)},d.hash=function(t,e){return d.hashBinary(s(t),e)},d.hashBinary=function(t,e){var r=i(t),n=o(r);return e?l(n):n},d.ArrayBuffer=function(){this.reset()},d.ArrayBuffer.prototype.append=function(t){var r,i=h(this._buff.buffer,t,!0),a=i.length;for(this._length+=t.byteLength,r=64;r<=a;r+=64)e(this._hash,n(i.subarray(r-64,r)));return this._buff=r-64<a?new Uint8Array(i.buffer.slice(r-64)):new Uint8Array(0),this},d.ArrayBuffer.prototype.end=function(t){var e,r,n=this._buff,i=n.length,a=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];for(e=0;e<i;e+=1)a[e>>2]|=n[e]<<(e%4<<3);return this._finish(a,i),r=o(this._hash),t&&(r=l(r)),this.reset(),r},d.ArrayBuffer.prototype.reset=function(){return this._buff=new Uint8Array(0),this._length=0,this._hash=[1732584193,-271733879,-1732584194,271733878],this},d.ArrayBuffer.prototype.getState=function(){var t=d.prototype.getState.call(this);return t.buff=c(t.buff),t},d.ArrayBuffer.prototype.setState=function(t){return t.buff=f(t.buff,!0),d.prototype.setState.call(this,t)},d.ArrayBuffer.prototype.destroy=d.prototype.destroy,d.ArrayBuffer.prototype._finish=d.prototype._finish,d.ArrayBuffer.hash=function(t,e){var r=a(new Uint8Array(t)),n=o(r);return e?l(n):n},d})},function(t,e,r){"use strict";function n(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}r.d(e,"a",function(){return u});var i=r(0),a=function(){function t(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}return function(e,r,n){return r&&t(e.prototype,r),n&&t(e,n),e}}(),u=function(){function t(e,r,a){var u=this;n(this,t),this.file=e,this.attributes={filename:e.name,content_type:e.type,byte_size:e.size,checksum:r},this.xhr=new XMLHttpRequest,this.xhr.open("POST",a,!0),this.xhr.responseType="json",this.xhr.setRequestHeader("Content-Type","application/json"),this.xhr.setRequestHeader("Accept","application/json"),this.xhr.setRequestHeader("X-Requested-With","XMLHttpRequest"),this.xhr.setRequestHeader("X-CSRF-Token",Object(i.d)("csrf-token")),this.xhr.addEventListener("load",function(t){return u.requestDidLoad(t)}),this.xhr.addEventListener("error",function(t){return u.requestDidError(t)})}return a(t,[{key:"create",value:function(t){this.callback=t,this.xhr.send(JSON.stringify({blob:this.attributes}))}},{key:"requestDidLoad",value:function(t){if(this.status>=200&&this.status<300){var e=this.response,r=e.direct_upload;delete e.direct_upload,this.attributes=e,this.directUploadData=r,this.callback(null,this.toJSON())}else this.requestDidError(t)}},{key:"requestDidError",value:function(t){this.callback('Error creating Blob for "'+this.file.name+'". Status: '+this.status)}},{key:"toJSON",value:function(){var t={};for(var e in this.attributes)t[e]=this.attributes[e];return t}},{key:"status",get:function(){return this.xhr.status}},{key:"response",get:function(){var t=this.xhr,e=t.responseType,r=t.response;return"json"==e?r:JSON.parse(r)}}]),t}()},function(t,e,r){"use strict";function n(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}r.d(e,"a",function(){return a});var i=function(){function t(t,e){for(var r=0;r<e.length;r++){var n=e[r];n.enumerable=n.enumerable||!1,n.configurable=!0,"value"in n&&(n.writable=!0),Object.defineProperty(t,n.key,n)}}return function(e,r,n){return r&&t(e.prototype,r),n&&t(e,n),e}}(),a=function(){function t(e){var r=this;n(this,t),this.blob=e,this.file=e.file;var i=e.directUploadData,a=i.url,u=i.headers;this.xhr=new XMLHttpRequest,this.xhr.open("PUT",a,!0),this.xhr.responseType="text";for(var o in u)this.xhr.setRequestHeader(o,u[o]);this.xhr.addEventListener("load",function(t){return r.requestDidLoad(t)}),this.xhr.addEventListener("error",function(t){return r.requestDidError(t)})}return i(t,[{key:"create",value:function(t){this.callback=t,this.xhr.send(this.file.slice())}},{key:"requestDidLoad",value:function(t){var e=this.xhr,r=e.status,n=e.response;r>=200&&r<300?this.callback(null,n):this.requestDidError(t)}},{key:"requestDidError",value:function(t){this.callback('Error storing "'+this.file.name+'". Status: '+this.xhr.status)}}]),t}()}])});
function copy(id) {
  // Crea un campo de texto "oculto"
  var aux = document.createElement("input");
  // Asigna el contenido del elemento especificado al valor del campo
  aux.setAttribute("value", $("#"+id).val());
  // Añade el campo a la página
  document.body.appendChild(aux);
  // Selecciona el contenido del campo
  aux.select();
  // Copia el texto seleccionado
  document.execCommand("copy");
  // Elimina el campo de la página
  document.body.removeChild(aux);
}

function copyPartial(id) {
  const el = document.createElement('textarea');
  el.value = $("#partial"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}

function copyHtml(id) {
  const el = document.createElement('textarea');
  el.value = $("#"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}


$(document).on('turbolinks:load', function() {

  $(document).ready(function(){
    $('#btn-assets-editor').click(function(){
      $('#assets-editor').addClass('control-sidebar-open');
      loadSave()
    })

    $('#btn-theme-editor').click(function(){
      $('#theme-editor').addClass('control-sidebar-open');
      loadSave()
    })

    $('#btn-views-editor').click(function(){
      $('#views-editor').addClass('control-sidebar-open');
      loadSave()
    })

    $('#close-assets-editor').click(function(){
      $('#assets-editor').removeClass('control-sidebar-open');
    })

    $('#close-theme-editor').click(function(){
      $('#theme-editor').removeClass('control-sidebar-open');
    })

    $('#close-views-editor').click(function(){
      $('#views-editor').removeClass('control-sidebar-open');
    })
  })

  function loadSave() {
    $(document).keypress("s",function(e) {
      if(e.ctrlKey && e.key=='s') {
        e.preventDefault();
        if ( tab === `#{@view.name}.html.erb`) {
          alert("pasooo")
          codeHTML.save(id);
        } else if (tab === `#{@view.name}.scss`) {
          codeCSS.save(id);
        } else if (tab === `#{@view.name}.js`) {
          codeJs.save(id);
        } else if (tab === 'Action') {
          codeAction.save(id);
        }
      }
    });
  }
});
/*
 * bootstrap-tagsinput v0.6.1 by Tim Schlechter
 *
 */


!function(a){"use strict";function b(b,c){this.itemsArray=[],this.$element=a(b),this.$element.hide(),this.isSelect="SELECT"===b.tagName,this.multiple=this.isSelect&&b.hasAttribute("multiple"),this.objectItems=c&&c.itemValue,this.placeholderText=b.hasAttribute("placeholder")?this.$element.attr("placeholder"):"",this.inputSize=Math.max(1,this.placeholderText.length),this.$container=a('<div class="bootstrap-tagsinput"></div>'),this.$input=a('<input type="text" placeholder="'+this.placeholderText+'"/>').appendTo(this.$container),this.$element.before(this.$container),this.build(c)}function c(a,b){if("function"!=typeof a[b]){var c=a[b];a[b]=function(a){return a[c]}}}function d(a,b){if("function"!=typeof a[b]){var c=a[b];a[b]=function(){return c}}}function e(a){return a?i.text(a).html():""}function f(a){var b=0;if(document.selection){a.focus();var c=document.selection.createRange();c.moveStart("character",-a.value.length),b=c.text.length}else(a.selectionStart||"0"==a.selectionStart)&&(b=a.selectionStart);return b}function g(b,c){var d=!1;return a.each(c,function(a,c){if("number"==typeof c&&b.which===c)return d=!0,!1;if(b.which===c.which){var e=!c.hasOwnProperty("altKey")||b.altKey===c.altKey,f=!c.hasOwnProperty("shiftKey")||b.shiftKey===c.shiftKey,g=!c.hasOwnProperty("ctrlKey")||b.ctrlKey===c.ctrlKey;if(e&&f&&g)return d=!0,!1}}),d}var h={tagClass:function(a){return"label label-keppler"},itemValue:function(a){return a?a.toString():a},itemText:function(a){return this.itemValue(a)},itemTitle:function(a){return null},freeInput:!0,addOnBlur:!0,maxTags:void 0,maxChars:void 0,confirmKeys:[13,44],delimiter:",",delimiterRegex:null,cancelConfirmKeysOnEmpty:!0,onTagExists:function(a,b){b.hide().fadeIn()},trimValue:!1,allowDuplicates:!1};b.prototype={constructor:b,add:function(b,c,d){var f=this;if(!(f.options.maxTags&&f.itemsArray.length>=f.options.maxTags)&&(b===!1||b)){if("string"==typeof b&&f.options.trimValue&&(b=a.trim(b)),"object"==typeof b&&!f.objectItems)throw"Can't add objects when itemValue option is not set";if(!b.toString().match(/^\s*$/)){if(f.isSelect&&!f.multiple&&f.itemsArray.length>0&&f.remove(f.itemsArray[0]),"string"==typeof b&&"INPUT"===this.$element[0].tagName){var g=f.options.delimiterRegex?f.options.delimiterRegex:f.options.delimiter,h=b.split(g);if(h.length>1){for(var i=0;i<h.length;i++)this.add(h[i],!0);return void(c||f.pushVal())}}var j=f.options.itemValue(b),k=f.options.itemText(b),l=f.options.tagClass(b),m=f.options.itemTitle(b),n=a.grep(f.itemsArray,function(a){return f.options.itemValue(a)===j})[0];if(!n||f.options.allowDuplicates){if(!(f.items().toString().length+b.length+1>f.options.maxInputLength)){var o=a.Event("beforeItemAdd",{item:b,cancel:!1,options:d});if(f.$element.trigger(o),!o.cancel){f.itemsArray.push(b);var p=a('<span class="tag '+e(l)+(null!==m?'" title="'+m:"")+'">'+e(k)+'<span data-role="remove"></span></span>');if(p.data("item",b),f.findInputWrapper().before(p),p.after(" "),f.isSelect&&!a('option[value="'+encodeURIComponent(j)+'"]',f.$element)[0]){var q=a("<option selected>"+e(k)+"</option>");q.data("item",b),q.attr("value",j),f.$element.append(q)}c||f.pushVal(),(f.options.maxTags===f.itemsArray.length||f.items().toString().length===f.options.maxInputLength)&&f.$container.addClass("bootstrap-tagsinput-max"),f.$element.trigger(a.Event("itemAdded",{item:b,options:d}))}}}else if(f.options.onTagExists){var r=a(".tag",f.$container).filter(function(){return a(this).data("item")===n});f.options.onTagExists(b,r)}}}},remove:function(b,c,d){var e=this;if(e.objectItems&&(b="object"==typeof b?a.grep(e.itemsArray,function(a){return e.options.itemValue(a)==e.options.itemValue(b)}):a.grep(e.itemsArray,function(a){return e.options.itemValue(a)==b}),b=b[b.length-1]),b){var f=a.Event("beforeItemRemove",{item:b,cancel:!1,options:d});if(e.$element.trigger(f),f.cancel)return;a(".tag",e.$container).filter(function(){return a(this).data("item")===b}).remove(),a("option",e.$element).filter(function(){return a(this).data("item")===b}).remove(),-1!==a.inArray(b,e.itemsArray)&&e.itemsArray.splice(a.inArray(b,e.itemsArray),1)}c||e.pushVal(),e.options.maxTags>e.itemsArray.length&&e.$container.removeClass("bootstrap-tagsinput-max"),e.$element.trigger(a.Event("itemRemoved",{item:b,options:d}))},removeAll:function(){var b=this;for(a(".tag",b.$container).remove(),a("option",b.$element).remove();b.itemsArray.length>0;)b.itemsArray.pop();b.pushVal()},refresh:function(){var b=this;a(".tag",b.$container).each(function(){var c=a(this),d=c.data("item"),f=b.options.itemValue(d),g=b.options.itemText(d),h=b.options.tagClass(d);if(c.attr("class",null),c.addClass("tag "+e(h)),c.contents().filter(function(){return 3==this.nodeType})[0].nodeValue=e(g),b.isSelect){var i=a("option",b.$element).filter(function(){return a(this).data("item")===d});i.attr("value",f)}})},items:function(){return this.itemsArray},pushVal:function(){var b=this,c=a.map(b.items(),function(a){return b.options.itemValue(a).toString()});b.$element.val(c,!0).trigger("change")},build:function(b){var e=this;if(e.options=a.extend({},h,b),e.objectItems&&(e.options.freeInput=!1),c(e.options,"itemValue"),c(e.options,"itemText"),d(e.options,"tagClass"),e.options.typeahead){var i=e.options.typeahead||{};d(i,"source"),e.$input.typeahead(a.extend({},i,{source:function(b,c){function d(a){for(var b=[],d=0;d<a.length;d++){var g=e.options.itemText(a[d]);f[g]=a[d],b.push(g)}c(b)}this.map={};var f=this.map,g=i.source(b);a.isFunction(g.success)?g.success(d):a.isFunction(g.then)?g.then(d):a.when(g).then(d)},updater:function(a){return e.add(this.map[a]),this.map[a]},matcher:function(a){return-1!==a.toLowerCase().indexOf(this.query.trim().toLowerCase())},sorter:function(a){return a.sort()},highlighter:function(a){var b=new RegExp("("+this.query+")","gi");return a.replace(b,"<strong>$1</strong>")}}))}if(e.options.typeaheadjs){var j=null,k={},l=e.options.typeaheadjs;a.isArray(l)?(j=l[0],k=l[1]):k=l,e.$input.typeahead(j,k).on("typeahead:selected",a.proxy(function(a,b){k.valueKey?e.add(b[k.valueKey]):e.add(b),e.$input.typeahead("val","")},e))}e.$container.on("click",a.proxy(function(a){e.$element.attr("disabled")||e.$input.removeAttr("disabled"),e.$input.focus()},e)),e.options.addOnBlur&&e.options.freeInput&&e.$input.on("focusout",a.proxy(function(b){0===a(".typeahead, .twitter-typeahead",e.$container).length&&(e.add(e.$input.val()),e.$input.val(""))},e)),e.$container.on("keydown","input",a.proxy(function(b){var c=a(b.target),d=e.findInputWrapper();if(e.$element.attr("disabled"))return void e.$input.attr("disabled","disabled");switch(b.which){case 8:if(0===f(c[0])){var g=d.prev();g.length&&e.remove(g.data("item"))}break;case 46:if(0===f(c[0])){var h=d.next();h.length&&e.remove(h.data("item"))}break;case 37:var i=d.prev();0===c.val().length&&i[0]&&(i.before(d),c.focus());break;case 39:var j=d.next();0===c.val().length&&j[0]&&(j.after(d),c.focus())}var k=c.val().length;Math.ceil(k/5);c.attr("size",Math.max(this.inputSize,c.val().length))},e)),e.$container.on("keypress","input",a.proxy(function(b){var c=a(b.target);if(e.$element.attr("disabled"))return void e.$input.attr("disabled","disabled");var d=c.val(),f=e.options.maxChars&&d.length>=e.options.maxChars;e.options.freeInput&&(g(b,e.options.confirmKeys)||f)&&(0!==d.length&&(e.add(f?d.substr(0,e.options.maxChars):d),c.val("")),e.options.cancelConfirmKeysOnEmpty===!1&&b.preventDefault());var h=c.val().length;Math.ceil(h/5);c.attr("size",Math.max(this.inputSize,c.val().length))},e)),e.$container.on("click","[data-role=remove]",a.proxy(function(b){e.$element.attr("disabled")||e.remove(a(b.target).closest(".tag").data("item"))},e)),e.options.itemValue===h.itemValue&&("INPUT"===e.$element[0].tagName?e.add(e.$element.val()):a("option",e.$element).each(function(){e.add(a(this).attr("value"),!0)}))},destroy:function(){var a=this;a.$container.off("keypress","input"),a.$container.off("click","[role=remove]"),a.$container.remove(),a.$element.removeData("tagsinput"),a.$element.show()},focus:function(){this.$input.focus()},input:function(){return this.$input},findInputWrapper:function(){for(var b=this.$input[0],c=this.$container[0];b&&b.parentNode!==c;)b=b.parentNode;return a(b)}},a.fn.tagsinput=function(c,d,e){var f=[];return this.each(function(){var g=a(this).data("tagsinput");if(g)if(c||d){if(void 0!==g[c]){if(3===g[c].length&&void 0!==e)var h=g[c](d,null,e);else var h=g[c](d);void 0!==h&&f.push(h)}}else f.push(g);else g=new b(this,c),a(this).data("tagsinput",g),f.push(g),"SELECT"===this.tagName&&a("option",a(this)).attr("selected","selected"),a(this).val(a(this).val())}),"string"==typeof c?f.length>1?f:f[0]:f},a.fn.tagsinput.Constructor=b;var i=a("<div />");a(function(){a("input[data-role=tagsinput], select[multiple][data-role=tagsinput]").tagsinput()})}(window.jQuery);
//# sourceMappingURL=bootstrap-tagsinput.min.js.map
;
var editor = '';
var editor_css = '';
var editor_js = '';
var editor_js_erb = '';
var editor_action = '';
var editor_callback = '';
var editor_function = '';

var controls = {
  codes: {},
  save: function(id) {
    this.codes = {
      html: editor.getValue(),
      css: editor_css.getValue(),
      js: editor_js.getValue(),
      actions: editor_action.getValue()
    }
    $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
      $("#code-html").val(editor.getValue())
      $("#code-css").val(editor_css.getValue())
      $("#code-js").val(editor_js.getValue())
      $("#code-action").val(editor_action.getValue())
      $('.html_signal').css('display', 'none');
      $('.scss_signal').css('display', 'none');
      $('.js_signal').css('display', 'none');
      $('.action_signal').css('display', 'none');
    })
  },
  saveLayout: function(id){
    this.codes = {
      html: editor.getValue()
    }
    $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
      $("#code-html").val(editor.getValue())
      $('.html_signal').css('display', 'none');
    })
  },
  saveOnlyAction: function(){
    this.codes = {
      actions: editor.getValue()
    }
    $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
      $("#code-action").val(editor_action.getValue())
      $('.action_signal').css('display', 'none');
    })
  },
  saveViewJs: function(){
    this.codes = {
      actions: editor_action.getValue(),
      js_erb: editor_js_erb.getValue(),
    }
    $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
      $("#code-action").val(editor_action.getValue())
      $("#code-js-erb").val(editor_js_erb.getValue())
      $('.action_signal').css('display', 'none');
      $('.js_erb_signal').css('display', 'none');
    })
  }
}

var codeHTML = {
  codeMirrorHtml: function(code) {
    $("#code-html").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
        keyMap: "sublime",
        autoCloseBrackets: true,
        matchBrackets: true,
        theme: "monokai",
        tabSize: 2,
        autoCloseTags: true,
        matchTags: {bothTags: true},
        showTrailingSpace: true,
        showToken: /\w/,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {
          "Ctrl-Space": "autocomplete",
          "Ctrl-J": "toMatchingTag"
        }
      });

      editor.on('change', function () {
        if(editor.getValue() === $("#code-html").val()) {
          $('.html_signal').css('display', 'none');
        } else {
          $('.html_signal').css('display', 'block');
        }
      });
    });
    return editor;
  },
  save: function(id) {
    if(editor.getValue() !== $("#code-html").val()) {
      this.codes = {
        html: editor.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-html").val(editor.getValue())
        $('.html_signal').css('display', 'none');
      })
    }
  },

  saveLayout: function(id){
    if(editor.getValue() !== $("#code-html").val()) {
      this.codes = {
        html: editor.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-html").val(editor.getValue())
        $('.html_signal').css('display', 'none');
      })
    }
  },
}

var codeCSS = {
  codeMirrorCSS: function() {
    $("#code-css").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_css =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-scss",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        showTrailingSpace: true,
        tabSize: 2,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_css.on('change', function () {
        if(editor_css.getValue() === $("#code-css").val()) {
          $('.scss_signal').css('display', 'none');
        } else {
          $('.scss_signal').css('display', 'block');
        }
      });
    });
    return editor_css;
  },
  save: function(id) {
    if(editor_css.getValue() !== $("#code-css").val()) {
      this.codes = {
        css: editor_css.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-css").val(editor_css.getValue())
        $('.scss_signal').css('display', 'none');
      })
    }
  }
}

var codeJs = {
  codeMirrorJs: function() {
    $("#code-js").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_js =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/javascript",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_js.on('change', function () {
        if(editor_js.getValue() === $("#code-js").val()) {
          $('.js_signal').css('display', 'none');
        } else {
          $('.js_signal').css('display', 'block');
        }
      });
    });
    return editor_js;
  },
  save: function(id) {
    if(editor_js.getValue() !== $("#code-js").val()) {
      this.codes = {
        js: editor_js.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-js").val(editor_js.getValue())
        $('.js_signal').css('display', 'none');
      })
    }
  }
}

var codeJsErb = {
  codeMirrorJsErb: function() {
    $("#code-js-erb").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_js_erb =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/javascript",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_js_erb.on('change', function () {
        if(editor_js_erb.getValue() === $("#code-js").val()) {
          $('.js_erb_signal').css('display', 'none');
        } else {
          $('.js_erb_signal').css('display', 'block');
        }
      });
    });
    return editor_js;
  },
  save: function(id) {
    if(editor_js_erb.getValue() !== $("#code-js-erb").val()) {
      this.codes = {
        remote_js: editor_js_erb.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-js-erb").val(editor_js_erb.getValue())
        $('.js_erb_signal').css('display', 'none');
      })
    }
  }
}

var codeAction = {
  codeMirrorAction: function() {
    $("#code-action").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_action =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_action.on('change', function () {
        if(editor_action.getValue() === $("#code-action").val()) {
          $('.action_signal').css('display', 'none');
        } else {
          $('.action_signal').css('display', 'block');
        }
      });
    });
    return editor_action;
  },
  save: function(id) {
    if(editor_action.getValue() !== $("#code-action").val()) {
      this.codes = {
        actions: editor_action.getValue()
      }
      $.post("/admin/frontend/views/"+id+"/editor/save", this.codes, function(data){
        $("#code-action").val(editor_action.getValue())
        $('.action_signal').css('display', 'none');
      })
    }
  }
}

var codeCallback = {
  codeMirrorCallback: function() {
    $("#code-callback").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_callback =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        scrollbarStyle: "overlay",
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_callback.on('change', function () {
        if(editor_callback.getValue() === $("#code-action").val()) {
          $('.callback_signal').css('display', 'none');
        } else {
          $('.callback_signal').css('display', 'block');
        }
      });
    });
    return editor_callback;
  },
  save: function(id) {
    if(editor_callback.getValue() !== $("#code-callback").val()) {
      this.codes = {
        actions: editor_callback.getValue()
      }
      $.post("/admin/frontend/callback_functions/"+id+"/editor/save", this.codes, function(data){
        $("#code-callback").val(editor_callback.getValue())
        $('.callback_signal').css('display', 'none');
      })
    }
  }
}

var codeFunction = {
  codeMirrorFunction: function() {
    $("#code-function").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_function =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-ruby",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        scrollbarStyle: "overlay",
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });
      editor_function.on('change', function () {
        if(editor_function.getValue() === $("#code-function").val()) {
          $('.function_signal').css('display', 'none');
        } else {
          $('.function_signal').css('display', 'block');
        }
      });
    });
    return editor_function;
  },
  save: function(id) {
    if(editor_function.getValue() !== $("#code-function").val()) {
      this.codes = {
        actions: editor_function.getValue()
      }
      $.post("/admin/frontend/functions/"+id+"/editor/save", this.codes, function(data){
        $("#code-function").val(editor_callback.getValue())
        $('.function_signal').css('display', 'none');
      })
    }
  }
}
;
var editor_head = '';
var editor_header = '';
var editor_footer = '';

var controlsLayout = {
  codes: {},
  save: function(id) {
    this.codes = {
      head: editor_head.getValue(),
      header: editor_header.getValue(),
      footer: editor_footer.getValue()
    }
    $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
      $("#code-head").val(editor.getValue())
      $("#code-header").val(editor_header.getValue())
      $("#code-footer").val(editor_footer.getValue())
      $('.head_signal').css('display', 'none');
      $('.header_signal').css('display', 'none');
      $('.footer_signal').css('display', 'none');
    })
  }
}

var codeHead = {
  codeMirrorHead: function(code) {
    $("#code-head").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_head = CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
        keyMap: "sublime",
        autoCloseBrackets: true,
        matchBrackets: true,
        theme: "monokai",
        tabSize: 2,
        scrollbarStyle: "overlay",
        autoCloseTags: true,
        matchTags: {bothTags: true},
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {
          "Ctrl-Space": "autocomplete",
          "Ctrl-J": "toMatchingTag"
        }
      });

      editor_head.on('change', function () {
        if(editor_head.getValue() === $("#code-head").val()) {
          $('.head_signal').css('display', 'none');
        } else {
          $('.head_signal').css('display', 'block');
        }
      });
    });
    return editor_head
  },
  saveHead: function(id) {
    if(editor_head.getValue() !== $("#code-head").val()) {
      this.codes = {
        head: editor_head.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-head").val(editor_head.getValue())
        $('.head_signal').css('display', 'none');
      })
    }
  }
}

var codeHeader = {
  codeMirrorHeader: function() {
    $("#code-header").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_header =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        scrollbarStyle: "overlay",
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_header.on('change', function () {
        if(editor_header.getValue() === $("#code-header").val()) {
          $('.header_signal').css('display', 'none');
        } else {
          $('.header_signal').css('display', 'block');
        }
      });
    });
    return editor_header;
  },
  saveHeader: function(id) {
    if(editor_header.getValue() !== $("#code-header").val()) {
      this.codes = {
        header: editor_header.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-header").val(editor_header.getValue())
        $('.header_signal').css('display', 'none');
      })
    }
  }
}

var codeFooter = {
  codeMirrorFooter: function() {
    $("#code-footer").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor_footer =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        scrollbarStyle: "overlay",
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      editor_footer.on('change', function () {
        if(editor_footer.getValue() === $("#code-footer").val()) {
          $('.footer_signal').css('display', 'none');
        } else {
          $('.footer_signal').css('display', 'block');
        }
      });
    });
    return editor_footer;
  },
  saveFooter: function(id) {
    if(editor_footer.getValue() !== $("#code-footer").val()) {
      this.codes = {
        footer: editor_footer.getValue()
      }
      $.post("/admin/frontend/themes/"+id+"/editor/save", this.codes, function(data){
        $("#code-footer").val(editor_footer.getValue())
        $('.footer_signal').css('display', 'none');
      })
    }
  }
}
;
var editor = '';
var partial_editor_css = '';
var partial_editor_js = '';

var controlsPartial = {
  codes: {},
  savePartial: function(id) {
    this.codes = {
      html: editor.getValue(),
      scss: partial_editor_css.getValue(),
      js: partial_editor_js.getValue()
    }
    $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
      $("#code-html").val(editor.getValue())
      $("#code-css").val(partial_editor_css.getValue())
      $("#code-js").val(partial_editor_js.getValue())
      $('.html_signal').css('display', 'none');
      $('.scss_signal').css('display', 'none');
      $('.js_signal').css('display', 'none');
    })
  }
}

var codePartialHTML = {
  codeMirrorHtml: function(code) {
    $("#code-html").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      editor = CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "application/x-ejs",
        keyMap: "sublime",
        autoCloseBrackets: true,
        matchBrackets: true,
        theme: "monokai",
        tabSize: 2,
        scrollbarStyle: "overlay",
        autoCloseTags: true,
        matchTags: {bothTags: true},
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {
          "Ctrl-Space": "autocomplete",
          "Ctrl-J": "toMatchingTag"
        }
      });

      editor.on('change', function () {
        if(editor.getValue() === $("#code-html").val()) {
          $('.html_signal').css('display', 'none');
        } else {
          $('.html_signal').css('display', 'block');
        }
      });
    });
    return editor
  },
  savePartial: function(id) {
    if(editor.getValue() !== $("#code-html").val()) {
      this.codes = {
        html: editor.getValue()
      }
      $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
        $("#code-html").val(editor.getValue())
        $('.html_signal').css('display', 'none');
      })
    }
  }
}

var codePartialCSS = {
  codeMirrorCSS: function() {
    $("#code-css").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      partial_editor_css = CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/x-scss",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        showTrailingSpace: true,
        tabSize: 2,
        scrollbarStyle: "overlay",
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      partial_editor_css.on('change', function () {
        if(partial_editor_css.getValue() === $("#code-css").val()) {
          $('.scss_signal').css('display', 'none');
        } else {
          $('.scss_signal').css('display', 'block');
        }
      });
    });
    return partial_editor_css;
  },
  savePartial: function(id) {
    if(partial_editor_css.getValue() !== $("#code-css").val()) {
      this.codes = {
        scss: partial_editor_css.getValue()
      }
      $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
        $("#code-css").val(partial_editor_css.getValue())
        $('.scss_signal').css('display', 'none');
      })
    }
  }
}

var codePartialJs = {
  codeMirrorJs: function() {
    $("#code-js").each(function() {
      CodeMirror.commands.autocomplete = function(cm) {
        cm.showHint({hint: CodeMirror.hint.anyword});
      }
      partial_editor_js =  CodeMirror.fromTextArea($(this).get(0), {
        lineNumbers: true,
        mode: "text/javascript",
        keyMap: "sublime",
        theme: 'monokai',
        autoCloseBrackets: true,
        matchBrackets: true,
        indentUnit: 2,
        tabSize: 2,
        scrollbarStyle: "overlay",
        showTrailingSpace: true,
        highlightSelectionMatches: {
          showToken: /\w/,
          annotateScrollbar: true
        },
        extraKeys: {"Ctrl-Space": "autocomplete"}
      });

      partial_editor_js.on('change', function () {
        if(partial_editor_js.getValue() === $("#code-js").val()) {
          $('.js_signal').css('display', 'none');
        } else {
          $('.js_signal').css('display', 'block');
        }
      });
    });
    return partial_editor_js;
  },
  savePartial: function(id) {
    if(partial_editor_js.getValue() !== $("#code-js").val()) {
      this.codes = {
        js: partial_editor_js.getValue()
      }
      $.post("/admin/frontend/partials/"+id+"/editor/save", this.codes, function(data){
        $("#code-js").val(partial_editor_js.getValue())
        $('.js_signal').css('display', 'none');
      })
    }
  }
}


function copyHtml(id) {
  const el = document.createElement('textarea');
  el.value = $("#"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}

function copyPartial(id) {
  const el = document.createElement('textarea');
  el.value = $("#partial"+id)[0].attributes.value.value;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
}
;
$(document).ready(function() {
  $('#xs').click(function() {
    $('#box-body').animate({ 'width': '35%' }, 300)
  })

  $('#md').click(function() {
    $('#box-body').animate({ 'width': '70%' }, 300)
  })

  $('#lg').click(function() {
    $('#box-body').animate({ 'width': '100%' }, 300)
  })

  $('#reload').click(function() {
    var url = document.getElementById("preview").contentWindow.location.href
    $('iframe').attr('src', url)
  })
});
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.


;
