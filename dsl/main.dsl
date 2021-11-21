context {
    input endpoint: string;
}

external function sendResponse(data: unknown): boolean;

start node root //start node
{
  do
  {
    #connectSafe($endpoint); //connect via phone
    #waitForSpeech(1000);
    #sayText("This is Dasha from oh pee call. Your friend white tiger has overdosed near 1151 Richmond Street, London, Ontario. We've sent the location through text. Please bring your Naloxone kit if it is safe to do so. Will you be administering naloxone to white tiger?");
    wait *; //wait for user speech
  }
  transitions 
  {
    yes: goto yes on #messageHasIntent("yes");
    no: goto no on #messageHasIntent("no");

  }
}

node yes
{
  do
  {
    external sendResponse(#messageGetData("help"));
    #sayText("We've notified white tiger that you are on the way with naloxone. Thank you for being a good samaritan. Please stay safe, and always call 9 1 1 when required.");
    #disconnect();
    exit;
  }
}

node no
{
  do
  {
    #sayText("Okay, we have not notified whitetiger that you declined. Please stay safe.");
    #disconnect();
    exit;
  }
}