var version=sap.ui.version.split(".");if(parseInt(version[0])<=1&&parseInt(version[1])<78){sap.ui.getCore().loadLibraries(["sap/ui/fl"]);sap.ui.require(["sap/ui/fl/FakeLrepConnector"],function(e){jQuery.extend(e.prototype,{create:function(e){return Promi+
se.resolve()},stringToAscii:function(e){if(!e||e.length===0){return""}var n="";for(var t=0;t<e.length;t++){n+=e.charCodeAt(t)+","}if(n!==null&&n.length>0&&n.charAt(n.length-1)===","){n=n.substring(0,n.length-1)}return n},loadChanges:function(){var n={cha+
nges:[],settings:{isKeyUser:true,isAtoAvailable:false,isProductiveSystem:false}};var t=[];var a="/sap-ui-cachebuster-info.json";var o=[/^localhost$/,/^.*.applicationstudio.cloud.sap$/];var i=new URL(window.location.toString());var r=o.some(e=>e.test(i.ho+
stname));return new Promise(function(o,c){if(!r)c(console.log("cannot load flex changes: invalid host"));$.ajax({url:i.origin+a,type:"GET",cache:false}).then(function(e){var n=Object.keys(e).filter(function(e){return e.endsWith(".change")});$.each(n,func+
tion(e,n){if(n.indexOf("changes")===0){if(!r)c(console.log("cannot load flex changes: invalid host"));t.push($.ajax({url:i.origin+"/"+n,type:"GET",cache:false}).then(function(e){return JSON.parse(e)}))}})}).always(function(){return Promise.all(t).then(fu+
nction(a){return new Promise(function(e,n){if(a.length===0){if(!r)n(console.log("cannot load flex changes: invalid host"));$.ajax({url:i.origin+"/changes/",type:"GET",cache:false}).then(function(a){var o=/(\/changes\/[^"]*\.[a-zA-Z]*)/g;var c=o.exec(a);w+
hile(c!==null){if(!r)n(console.log("cannot load flex changes: invalid host"));t.push($.ajax({url:i.origin+c[1],type:"GET",cache:false}).then(function(e){return JSON.parse(e)}));c=o.exec(a)}e(Promise.all(t))}).fail(function(n){e(a)})}else{e(a)}}).then(fun+
ction(t){var a=[],i=[];t.forEach(function(n){var t=n.changeType;if(t==="addXML"||t==="codeExt"){var o=t==="addXML"?n.content.fragmentPath:t==="codeExt"?n.content.codeRef:"";var r=o.match(/webapp(.*)/);var c="/"+r[0];a.push($.ajax({url:c,type:"GET",cache:+
false}).then(function(a){if(t==="addXML"){n.content.fragment=e.prototype.stringToAscii(a.documentElement.outerHTML);n.content.selectedFragmentContent=a.documentElement.outerHTML}else if(t==="codeExt"){n.content.code=e.prototype.stringToAscii(a);n.content+
.extensionControllerContent=a}return n}))}else{i.push(n)}});if(a.length>0){return Promise.all(a).then(function(e){e.forEach(function(e){i.push(e)});i.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=i;var t={changes:n,compo+
nentClassName:"umicore.mm.zui5mmcaddiv.zui5mmcaddiv"};o(t)})}else{i.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=i;var r={changes:n,componentClassName:"umicore.mm.zui5mmcaddiv.zui5mmcaddiv"};o(r)}})})})})}});e.enableFak+
eConnector()})}                                                                                                                                                                                                                                                