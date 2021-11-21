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
    #sayText("Hi whitetiger, this is Dasha calling from opiCall. Are you alright?");
    wait *; //wait for user speech
  }
  transitions
  {
    status_okay: goto status_okay on #messageHasIntent("status_okay");
    status_not_okay: goto status_not_okay on #messageHasIntent("status_not_okay");
    status_overdose: goto status_overdose on #messageHasIntent("status_overdose");
  }
}

node status_okay
{
  do
  {
    #sayText("Glad to hear you're okay. If you ever need any help, reach out. Stay safe!");
    #disconnect();
    exit;
  }
}

node status_not_okay
{
  do
  {
    #sayText("Are you feeling dizzy or confused?");
    wait *; //wait for user speech
  }
  transitions
  {
    status_okay: goto status_okay on #messageHasIntent("no_symptoms");
    status_dizzy: goto status_dizzy on #messageHasIntent("status_dizzy");
    status_overdose: goto status_overdose on #messageHasIntent("status_overdose");
  }
}


node status_dizzy
{
  do
  {
    #sayText("Are you having difficulty breathing or staying awake?");
    wait *; //wait for user speech
  }
  transitions
  {
    status_caution: goto status_caution on #messageHasIntent("no_symptoms");
    status_overdose: goto status_overdose on #messageHasAnyIntent(["status_nobreatheorawake", "status_overdose"]);
  }
}


node status_caution
{
  do
  {
    #sayText("Please be careful. You're experiencing some symptoms and may be at risk of an overdose if you continue. Stay safe, whitetiger.");
    #disconnect();
    exit; // TODO: set status of user to caution/warning/lookout
  }
}



node status_overdose
{
  do
  {
    external sendResponse(#messageGetData("symptom"));
    #sayText("Stay on the line. Don't worry, help is on the way. We've alerted the opiCall network and help will be there for you very soon.");
    wait *;
  }
}