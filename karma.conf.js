module.exports = function(config) {
    config.set({
        preprocessors: {
            "./intermediate_build_files/src/**/*.elm": ['elm'],
            "./tests/**/*.elm": ['elm']
        },
        frameworks: ["elm-test"],
        files: ["./intermediate_build_files/src/**/*.elm", "./tests/**/*.elm"],
        client : {
            "elm-test":{
                suites:[
                    {
                        module:"TabbedPaneTest",
                        tests:["TabbedPaneTest.suite"]
                    }
                ],
                "test-source-directories" : [
                    "./tests"
                ]
            }
        },
        browsers: ['Chrome','Edge'],
        autoWatch:true,
        singleRun:false
    });
};