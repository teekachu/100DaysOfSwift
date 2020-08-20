var Action = function(){};

Action.prototype = {
    //called before extension is run
    run: function(parameters){
        //javascript has finished PREPROCESSING, provide the dictionary data below to IOS
        parameters.completionFunction({
            "URL": document.URL,
            "title": document.title
//            "body": document.body
        })
    },
    //called after extension is run
    finalize: function(parameters){
        var customJavaScript = parameters["customJavaScript"];
        eval(customJavaScript)
    }
};

var ExtensionPreprocessingJS = new Action
