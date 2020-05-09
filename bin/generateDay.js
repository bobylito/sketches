const shell = require("shelljs");
const { join, basename } = require("path");

const p = join(process.cwd(), "code", "*");
const lastDayFolder = shell
  .ls("-d", p)
  .filter((f) => f.indexOf("day") != -1)
  .reverse()[0];

const lastDay = parseInt(basename(lastDayFolder).replace("day", ""));
const today = lastDay + 1;

const targetFolder = join(process.cwd(), "code", `day${today}`);
const templateFolder = join(process.cwd(), "code", "templates", "shader");

shell.cp("-R", templateFolder, targetFolder);

// By convention, the PDE should have the folder name
shell.mv(
  join(targetFolder, "sketch.pde"),
  join(targetFolder, `day${today}.pde`)
);

shell.cd(targetFolder);

shell.exec("npm install");
