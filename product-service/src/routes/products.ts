import { Router } from "express";
import prisma from "../prismaClient";

const router = Router();

router.get("/", async (_, res) => {
  const products = await prisma.product.findMany();
  res.json(products);
});

export default router;
