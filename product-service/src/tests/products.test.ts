import request from "supertest";
import express from "express";
import productsRouter from "../routes/products";

const app = express();
app.use("/products", productsRouter);

it("GET /products returns 200", async () => {
  const res = await request(app).get("/products");
  expect(res.status).toBe(200);
});
