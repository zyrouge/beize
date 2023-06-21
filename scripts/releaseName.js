const { execSync } = require("child_process");

const getReleaseName = () => {
    const sha = execSync("git rev-parse HEAD").toString().substring(0, 7);
    const now = new Date();
    const date = now.getDate().toString().padStart(2, "0");
    const month = (now.getMonth() + 1).toString().padStart(2, "0");
    const year = now.getFullYear().toString();
    return `v${year}.${month}.${date}-${sha}`;
};

module.exports = { getReleaseName };
