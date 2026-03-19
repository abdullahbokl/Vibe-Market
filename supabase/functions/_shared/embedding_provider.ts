import { InferenceClient } from "https://esm.sh/@huggingface/inference@4.13.15";

export const embeddingDimension = 768;
export const embeddingModel = "google/embeddinggemma-300m";

const conceptAliases: Record<string, string[]> = {
  jacket: ["outerwear", "shell", "coat", "windbreaker", "runner"],
  outerwear: ["jacket", "shell", "coat", "layer"],
  watch: ["timepiece", "chronograph", "collector", "luxury"],
  audio: ["headphones", "music", "listening", "sound", "studio"],
  bag: ["duffel", "travel", "carry", "weekender", "sling"],
  sneakers: ["shoes", "runner", "footwear", "streetwear"],
  coffee: ["espresso", "brew", "pour_over", "cafe", "barista"],
  desk: ["workspace", "studio", "lamp", "setup", "home_office"],
  camera: ["photography", "photo", "lens", "creator"],
  fragrance: ["perfume", "scent", "cologne", "aroma"],
  knit: ["overshirt", "layer", "texture", "soft"],
  minimal: ["clean", "premium", "refined", "restrained"],
  luxury: ["premium", "collector", "limited", "elevated"],
  travel: ["carry", "bag", "weekender", "trip"],
  running: ["runner", "performance", "training", "active"],
};

export async function embedText(input: string): Promise<number[]> {
  const hfToken = Deno.env.get("HF_TOKEN") ?? "";
  if (hfToken) {
    const hf = new InferenceClient(hfToken);
    const embedding = await hf.featureExtraction({
      model: embeddingModel,
      inputs: input,
      normalize: true,
    });
    if (
      Array.isArray(embedding) &&
      embedding.length === embeddingDimension &&
      embedding.every((value) => typeof value === "number")
    ) {
      return embedding;
    }
    throw new Error("Embedding provider returned an invalid vector.");
  }

  return buildFakeEmbedding(input);
}

function buildFakeEmbedding(input: string): number[] {
  const vector = Array.from(
    { length: embeddingDimension },
    () => 0,
  );

  finalTokens(input).forEach((token, index) => {
    const weight = 1 + ((token.length % 7) * 0.12) + ((index % 5) * 0.05);
    const primaryIndex = stableIndex(`${token}::primary`);
    const secondaryIndex = stableIndex(`${token}::secondary`);
    vector[primaryIndex] += weight;
    vector[secondaryIndex] += weight * 0.45;
  });

  return normalize(vector);
}

function finalTokens(input: string): string[] {
  const baseTokens = input
    .toLowerCase()
    .replaceAll(/[^a-z0-9\s-]/g, " ")
    .split(/[\s-]+/)
    .filter((token) => token.length > 0);

  const expandedTokens = [
    ...baseTokens,
    ...expandAliases(baseTokens),
    ...buildBigrams(baseTokens),
  ];

  return expandedTokens.slice(0, 256);
}

function expandAliases(tokens: string[]): string[] {
  return tokens.flatMap((token) => conceptAliases[token] ?? []);
}

function buildBigrams(tokens: string[]): string[] {
  const bigrams: string[] = [];
  for (let index = 0; index < tokens.length - 1; index += 1) {
    bigrams.push(`${tokens[index]}_${tokens[index + 1]}`);
  }
  return bigrams;
}

function stableIndex(token: string): number {
  return stableHash(token) % embeddingDimension;
}

function stableHash(input: string): number {
  let hash = 2166136261;
  for (const codeUnit of input) {
    hash ^= codeUnit.charCodeAt(0);
    hash = Math.imul(hash, 16777619) >>> 0;
  }
  return hash;
}

function normalize(vector: number[]): number[] {
  const magnitude = Math.sqrt(
    vector.reduce((sum, value) => sum + value * value, 0),
  );
  if (!Number.isFinite(magnitude) || magnitude === 0) {
    return vector.map((_, index) => index === 0 ? 1 : 0);
  }

  return vector.map((value) => value / magnitude);
}
