/**
 * Created by stephen.hand on 15/08/2017.
 */
const fs = require("fs");
const gulp = require("gulp");
const git = require("gulp-git");
const modify = require("gulp-modify-file");
const gitRepo="https://github.com/stephenhand/elm-xslt.git", gitTag="1.0.0", moduleName="stephenhand/elm-xslt", version="1.0.0";

gulp.task("git-elm-modules", function(cb) {
    const elmStuffPath = `./elm-stuff/packages/${moduleName}/${version}`;
    return gulp.src(["./elm-stuff/exact-dependencies.json"], {base: './'})
    //update exact-dependencies.json
        .pipe(modify(function(exactDepsJson){
            let deps=JSON.parse(exactDepsJson);
            console.log("updating exact-dependencies.json");
            deps[moduleName] = version;
            console.log(`exact-dependencies.json: ${JSON.stringify(deps)}`);
            return JSON.stringify(deps, null, 2);
        }))
        .pipe(gulp.dest("./"))
        .on("end", function(){
            git.clone(gitRepo, {args: `--single-branch --depth 1 ${elmStuffPath}`}, function(err) {
                if (err){
                    console.log(err);
                }
                git.checkout(version, {cwd:elmStuffPath},function(checkoutError){
                    if (checkoutError){
                        console.log(checkoutError);
                    }
                });
                // handle err
            });
        });

});

gulp.task("make-elm-app", function(){

});


