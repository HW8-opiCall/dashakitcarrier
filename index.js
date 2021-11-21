const dasha = require("@dasha.ai/sdk");
const fs = require("fs");

async function main() {
  const app = await dasha.deploy(`${__dirname}/dsl`);

  //app.setExternal("sendResponse", (args, conv) => {
  //  return JSON.stringify(args.data); // TODO
  //});

  await app.start();
  
  const logFile = await fs.promises.open("./log.txt", "w");
  await logFile.appendFile("#".repeat(100) + "\n");
  
  const conv = app.createConversation({ endpoint: process.argv[2] });
  
  conv.on("debugLog", async (event) => {
    if (event?.msg?.msgId === "RecognizedSpeechMessage") {
      const logEntry = event?.msg?.results[0]?.facts;
      await logFile.appendFile(JSON.stringify(logEntry, undefined, 2) + "\n");
    }
  });

  conv.sip.config = "twilio";
  conv.audio.tts = "dasha";

  const result = await conv.execute();
  console.log(result.output);

  await app.stop();
  app.dispose();
}


main();
