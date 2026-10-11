import { build } from 'esbuild';
import { cp, mkdir, readFile, rm } from 'node:fs/promises';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..');
for (const name of ['calculator', 'oddsjam']) {
  const source = resolve(root, 'extensions', name);
  const output = resolve(root, 'dist/extensions', name);
  const manifest = JSON.parse(await readFile(resolve(source, 'manifest.json'), 'utf8'));
  await rm(output, { recursive: true, force: true });
  await mkdir(output, { recursive: true });
  for (const resource of ['manifest.json', 'popup.html', 'css', 'images']) {
    await cp(resolve(source, resource), resolve(output, resource), { recursive: true });
  }
  const entries = ['popup.js'];
  if (manifest.background) entries.push(manifest.background.service_worker);
  for (const content of manifest.content_scripts ?? []) entries.push(...content.js);
  await build({
    absWorkingDir: source,
    entryPoints: entries,
    outdir: output,
    bundle: true,
    platform: 'browser',
    format: 'iife',
    target: 'chrome100',
    logLevel: 'info',
  });
  console.log(`Load unpacked: ${output}`);
}
