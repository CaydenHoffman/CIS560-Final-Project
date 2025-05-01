import express from "express";
import bodyParser from "body-parser";
import sql from "mssql/msnodesqlv8.js";

const app = express();
const port = 3000;

const sqlConfig = {
  server: "(localdb)\\MSSQLLocalDb",
  database: "daganspano",
  options: {
    trustedConnection: true,
    trustServerCertificate: true,
  },
  driver: "msnodesqlv8",
};

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

// GET home page
app.get("/", (req, res) => {
    res.render("index.ejs", { queryOne: null });
});

// GET query
app.get("/queryOne", async (req, res) => {
  try {
    await sql.connect(sqlConfig);
    const result = await sql.query`SELECT * FROM Clubs.Club`;
    let query = [];
    result.rows.forEach((row) => {
      query.push(row);
    });
    res.render("index.ejs", { queryOne: query });
  } catch (err) {
    console.error(err);
    res.send(err.message);
  }
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});