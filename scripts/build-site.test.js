// SPDX-License-Identifier: MPL-2.0
// SPDX-FileCopyrightText: 2026 Jonathan D.A. Jewell (hyperpolymath) <j.d.a.jewell@open.ac.uk>
import { describe, expect, test } from "bun:test";
import { build, normaliseBaseurl, parseArgs, urlFor } from "./build-site.mjs";

describe("site builder", () => {
  test("parses explicit config and output paths", () => {
    expect(parseArgs(["--config", "site.json", "--out", "_site"])).toEqual({
      config: "site.json",
      out: "_site",
      baseurl: "",
      dryRun: false,
    });
  });

  test("normalises a GitHub Pages base path", () => {
    expect(normaliseBaseurl("/phantom-metal-taste/")).toBe(
      "/phantom-metal-taste",
    );
    expect(normaliseBaseurl("/")).toBe("");
  });

  test("publishes and links root-level user documentation, licenses, and metadata", () => {
    const { outputs, published } = build({
      config: "site.json",
      out: "_site",
      baseurl: "",
      dryRun: true,
    });
    const paths = new Set(published.map((item) => item.site));
    for (const path of [
      ".well-known/ai.txt",
      ".well-known/humans.txt",
      ".well-known/security.txt",
      "LICENSE",
      "QUICKSTART.adoc",
      "TEST-NEEDS.adoc",
      "RSR_COMPLIANCE.adoc",
      "README.adoc",
    ]) {
      expect(paths.has(path)).toBe(true);
    }
    const html = outputs.get("index.html").toString();
    expect(html.includes('href="/QUICKSTART.adoc"')).toBe(true);
    expect(html.includes('href="/.well-known/security.txt"')).toBe(true);
    expect(html.includes("index.json")).toBe(false);
  });

  test("builds root and nested URLs without a base path", () => {
    expect(urlFor("", ".")).toBe("/");
    expect(urlFor("", "./docs/SETUP.adoc")).toBe("/docs/SETUP.adoc");
    expect(urlFor("", ".well-known/security.txt")).toBe(
      "/.well-known/security.txt",
    );
    expect(urlFor("", "docs/SETUP.adoc")).toBe("/docs/SETUP.adoc");
  });

  test("builds URLs below a project Pages base path", () => {
    expect(urlFor("/phantom-metal-taste", "docs/SETUP.adoc")).toBe(
      "/phantom-metal-taste/docs/SETUP.adoc",
    );
    const { outputs } = build({
      config: "site.json",
      out: "_site",
      baseurl: "/phantom-metal-taste",
      dryRun: true,
    });
    const html = outputs.get("index.html").toString();
    expect(
      html.includes('href="/phantom-metal-taste/.well-known/security.txt"'),
    ).toBe(true);
  });
});
