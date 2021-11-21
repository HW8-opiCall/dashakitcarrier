const dasha = require("@dasha.ai/sdk");
const fs = require("fs");
// const accountSid = process.env.TWILIO_ACCOUNT_SID;
// const authToken  = process.env.TWILIO_AUTH_TOKEN;
const accountSid = "";
const authToken  = "";
const client = require('twilio')(accountSid, authToken);


async function main() {
  const app = await dasha.deploy(`${__dirname}/dsl`);

  app.setExternal("sendResponse", (args, conv) => {
    client.messages
      .create({body: "\nYour friend blackbeetle is on the way. Please stay where you are so that blackbeetle does not get lost", from: '+12267814024', to: '+14167993015'})
      .then(message => console.log(message.sid));
  });

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
