/**
 * Created by stephen.hand on 15/08/2017.
 */
const fs = require("fs");
const gulp = require("gulp");
const clean = require("gulp-clean");
const git = require("gulp-git");
const modify = require("gulp-modify-file");
const elm = require("gulp-elm");
const {spawn} = require("child_process");
const gitRepo="https://github.com/stephenhand/elm-xslt.git", gitTag="1.0.0", moduleName="stephenhand/elm-xslt", version="1.0.0";
const intermediateBuildFolder = "intermediate_build_files";

gulp.task("restore-standard-elm-modules", (cb)=>{
    const packageProc = spawn("elm-package", ["install"]);
    packageProc.stdout.on("data", (data) => {
        if (data.toString().indexOf("[Y/n]")!==-1){
            packageProc.stdin.write("y\n");
        }
        console.log(`stdout: ${data}`);
    });
    packageProc.stderr.on("data", (data) => {
        console.log(`stderr: ${data}`);
    });
    packageProc.on("close", code=>cb()) ;
});

gulp.task("clean-build-area",  ()=>gulp.src([`./${intermediateBuildFolder}`]).pipe(clean({read:false})));

gulp.task("prepare-build-area", ["restore-standard-elm-modules", "clean-build-area"], ()=>gulp.src(["./elm-stuff/packages/**", "./elm-stuff/exact-dependencies.json", "./elm-package.json", "./src/**/*.elm"], {base: "./"}).pipe(gulp.dest(`./${intermediateBuildFolder}`)));

gulp.task("fix-project-deps", ["prepare-build-area"], ()=> {
    const elmStuffPath = `./${intermediateBuildFolder}/elm-stuff/packages/${moduleName}/${version}`;
    return gulp.src([`./${intermediateBuildFolder}/elm-stuff/exact-dependencies.json`,`./${intermediateBuildFolder}/elm-package.json`], {base: `./${intermediateBuildFolder}`})
    //update exact-dependencies.json
        .pipe(modify((exactDepsJson, path)=>{
            let parsed=JSON.parse(exactDepsJson);
            console.log(`updating ${path}`);

            if (path.endsWith("exact-dependencies.json")){
                parsed[moduleName] = version;
            }
            else if (path.endsWith("elm-package.json")) {
                parsed.dependencies = parsed.dependencies || {};
                let [major, minor, patch] = version.split(".");
                parsed.dependencies[moduleName] = `${version} <= v < ${major}.${minor}.${Number(patch)+1}`;
            }
            console.log(`${path}: ${JSON.stringify(parsed)}`);
            return JSON.stringify(parsed, null, 2);
        }))
        .pipe(gulp.dest(`./${intermediateBuildFolder}`))

});
gulp.task("restore-git-elm-modules", ["fix-project-deps"], (cb)=> {
    const elmStuffPath = `./${intermediateBuildFolder}/elm-stuff/packages/${moduleName}/${version}`;
    git.clone(gitRepo, {args: `--single-branch --depth 1 ${elmStuffPath}`}, function(err) {
        if (err){
            console.log(err);
        }
        git.checkout(version, {cwd:elmStuffPath},function(checkoutError){
            if (checkoutError){
                console.log(checkoutError);
            }
            cb();
        });
        // handle err

    });

});
gulp.task("elm-init", elm.init);

gulp.task("make-elm-app",["restore-git-elm-modules","elm-init"], ()=>{
    return gulp.src(`./${intermediateBuildFolder}/src/App.elm`)
        .pipe(elm.bundle("elm-app.js",{cwd:`./${intermediateBuildFolder}`}))
        .pipe(gulp.dest("./"));
});
