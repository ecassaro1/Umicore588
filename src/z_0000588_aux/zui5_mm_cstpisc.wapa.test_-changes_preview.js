var version=sap.ui.version.split(".");if(parseInt(version[0])<=1&&parseInt(version[1])<78){sap.ui.getCore().loadLibraries(["sap/ui/fl"]);sap.ui.require(["sap/ui/fl/FakeLrepConnector"],function(e){jQuery.extend(e.prototype,{create:function(e){return Promi+
se.resolve()},stringToAscii:function(e){if(!e||e.length===0){return""}var n="";for(var t=0;t<e.length;t++){n+=e.charCodeAt(t)+","}if(n!==null&&n.length>0&&n.charAt(n.length-1)===","){n=n.substring(0,n.length-1)}return n},loadChanges:function(){var n={cha+
nges:[],settings:{isKeyUser:true,isAtoAvailable:false,isProductiveSystem:false}};var t=[];var o="/sap-ui-cachebuster-info.json";var a=[/^localhost$/,/^.*.applicationstudio.cloud.sap$/];var i=new URL(window.location.toString());var r=a.some(e=>e.test(i.ho+
stname));return new Promise(function(a,c){if(!r)c(console.log("cannot load flex changes: invalid host"));$.ajax({url:i.origin+o,type:"GET",cache:false}).then(function(e){var n=Object.keys(e).filter(function(e){return e.endsWith(".change")});$.each(n,func+
tion(e,n){if(n.indexOf("changes")===0){if(!r)c(console.log("cannot load flex changes: invalid host"));t.push($.ajax({url:i.origin+"/"+n,type:"GET",cache:false}).then(function(e){return JSON.parse(e)}))}})}).always(function(){return Promise.all(t).then(fu+
nction(o){return new Promise(function(e,n){if(o.length===0){if(!r)n(console.log("cannot load flex changes: invalid host"));$.ajax({url:i.origin+"/changes/",type:"GET",cache:false}).then(function(o){var a=/(\/changes\/[^"]*\.[a-zA-Z]*)/g;var c=a.exec(o);w+
hile(c!==null){if(!r)n(console.log("cannot load flex changes: invalid host"));t.push($.ajax({url:i.origin+c[1],type:"GET",cache:false}).then(function(e){return JSON.parse(e)}));c=a.exec(o)}e(Promise.all(t))}).fail(function(n){e(o)})}else{e(o)}}).then(fun+
ction(t){var o=[],i=[];t.forEach(function(n){var t=n.changeType;if(t==="addXML"||t==="codeExt"){var a=t==="addXML"?n.content.fragmentPath:t==="codeExt"?n.content.codeRef:"";var r=a.match(/webapp(.*)/);var c="/"+r[0];o.push($.ajax({url:c,type:"GET",cache:+
false}).then(function(o){if(t==="addXML"){n.content.fragment=e.prototype.stringToAscii(o.documentElement.outerHTML);n.content.selectedFragmentContent=o.documentElement.outerHTML}else if(t==="codeExt"){n.content.code=e.prototype.stringToAscii(o);n.content+
.extensionControllerContent=o}return n}))}else{i.push(n)}});if(o.length>0){return Promise.all(o).then(function(e){e.forEach(function(e){i.push(e)});i.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=i;var t={changes:n,compo+
nentClassName:"umicore.mm.zui5mmcstpiscof.zui5mmcstpiscof"};a(t)})}else{i.sort(function(e,n){return new Date(e.creation)-new Date(n.creation)});n.changes=i;var r={changes:n,componentClassName:"umicore.mm.zui5mmcstpiscof.zui5mmcstpiscof"};a(r)}})})})})}})+
;e.enableFakeConnector()})}                                                                                                                                                                                                                                    