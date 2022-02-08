import { Buffer } from "node:buffer";
import { getInput, info, setFailed, setOutput, setSecret } from "@actions/core";
import { context } from "@actions/github";
import isBase64 from "is-base64";
import { fetchInstallationToken } from "./fetch-installation-token.js";
import { isStringRecord } from "./utils.js";

const run = async () => {
  try {
    const appId = getInput("app_id", { required: true });
    const privateKeyInput = getInput("private_key", { required: true });
    const privateKey = isBase64(privateKeyInput)
      ? Buffer.from(privateKeyInput, "base64").toString("utf8")
      : privateKeyInput;
    const permissionsInput = getInput("permissions", { required: true });
    const permissions: unknown = JSON.parse(permissionsInput);
    if (!isStringRecord(permissions))
      throw new Error("permissions must be an object");

    const installationId = getInput("installation_id");
    const repositoryInput = getInput("repository");
    const [owner, repo] = repositoryInput
      ? repositoryInput.split("/")
      : [context.repo.owner, context.repo.repo];

    const installationToken = await fetchInstallationToken({
      appId,
      installationId: installationId ? Number(installationId) : undefined,
      owner,
      permissions,
      privateKey,
      repo,
    });

    setSecret(installationToken);
    setOutput("token", installationToken);
    info("Token generated successfully!");
  } catch (error: unknown) {
    if (typeof error === "string" || error instanceof Error) {
      setFailed(error);
    } else {
      setFailed(`Caught error of unexpected type: ${typeof error}`);
    }
  }
};

void run();
