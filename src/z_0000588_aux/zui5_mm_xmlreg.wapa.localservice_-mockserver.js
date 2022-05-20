sap.ui.define(["sap/ui/core/util/MockServer"],function(e){"use strict";var t,r="umicore/mm/zui5mmxmlreg/zui5mmxmlreg/",a=r+"localService/mockdata";return{init:function(){var n=jQuery.sap.getUriParameters(),i=jQuery.sap.getModulePath(a),o=jQuery.sap.getMo+
dulePath(r+"manifest",".json"),s="XmlRegra",u=n.get("errorType"),p=u==="badRequest"?400:500,c=jQuery.sap.syncGetJSON(o).data,l=c["sap.app"].dataSources,m=l.mainService,f=jQuery.sap.getModulePath(r+m.settings.localUri.replace(".xml",""),".xml"),g=/.*\/$/.+
test(m.uri)?m.uri:m.uri+"/",d=m.settings.annotations;t=new e({rootUri:g});e.config({autoRespond:true,autoRespondAfter:n.get("serverDelay")||1e3});t.simulate(f,{sMockdataBaseUrl:i,bGenerateMissingMockData:true});var y=t.getRequests(),h=function(e,t,r){r.r+
esponse=function(r){r.respond(e,{"Content-Type":"text/plain;charset=utf-8"},t)}};if(n.get("metadataError")){y.forEach(function(e){if(e.path.toString().indexOf("$metadata")>-1){h(500,"metadata Error",e)}})}if(u){y.forEach(function(e){if(e.path.toString().+
indexOf(s)>-1){h(p,u,e)}})}t.start();jQuery.sap.log.info("Running the app with mock data");if(d&&d.length>0){d.forEach(function(t){var a=l[t],n=a.uri,i=jQuery.sap.getModulePath(r+a.settings.localUri.replace(".xml",""),".xml");new e({rootUri:n,requests:[{+
method:"GET",path:new RegExp("([?#].*)?"),response:function(e){jQuery.sap.require("jquery.sap.xml");var t=jQuery.sap.sjax({url:i,dataType:"xml"}).data;e.respondXML(200,{},jQuery.sap.serializeXML(t));return true}}]}).start()})}},getMockServer:function(){r+
eturn t}}});                                                                                                                                                                                                                                                   