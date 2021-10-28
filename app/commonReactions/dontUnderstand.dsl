library

context
{
    output status:string?;
    output serviceStatus:string?;
}

digression dont_understand
{
    conditions
    {
        on true priority -1000;
    }
    
    // set retriesLimit == -1 if retries are unlimited
    // set retriesLimit > 0 if you have limited dont_understand retries
    var retriesLimit = 1;
    var counter = 0;
    var resetOnRecognized = true;
    // set repeat_phrase == true if you want to repeat last phrase, overwise repeat_phrase == false
    var repeat_phrase = false;
    // add more phrases maps if you need to say something else
    var responses =
    {
        statement_phrases: ["dont_understand"],
        request_phrases:["dont_understand_request"],
        question_phrases: ["dont_understand_question"],
        default_phrases: ["dont_understand"]
    }
    ;
    
    do
    {
        if (digression.dont_understand.retriesLimit > 0)
        {
            if (digression.dont_understand.counter >= digression.dont_understand.retriesLimit)
            {
                goto hangup;
            }
            set digression.dont_understand.counter = digression.dont_understand.counter + 1;
            set digression.dont_understand.resetOnRecognized = false;
        }
        
        var sentenceType = #getSentenceType();
        var response: Phrases[] = [];
        if (sentenceType == "statement")
        {
            set response = digression.dont_understand.responses.statement_phrases;
        }
        else if (sentenceType == "request")
        {
            set response = digression.dont_understand.responses.request_phrases;
        }
        else if (sentenceType == "question")
        {
            set response = digression.dont_understand.responses.question_phrases;
        }
        else
        {
            set response = digression.dont_understand.responses.default_phrases;
        }
        for (var item in response)
        {
            #say(item, repeatMode: "ignore");
        }
        
        if (digression.dont_understand.repeat_phrase)
        {
            #repeat(accuracy: "short");
        }
        return;
    }
    
    transitions
    {
        hangup: goto dont_understand_hangup;
    }
}

preprocessor digression reset_counter
{
    conditions
    {
        on true priority 50000;
    }
    
    do
    {
        if (digression.dont_understand.resetOnRecognized)
        {
            set digression.dont_understand.counter = 0;
        }
        set digression.dont_understand.resetOnRecognized = true;
        return;
    }
}

node dont_understand_hangup
{
    do
    {
        // add more phrases maps if you need to say something else
        var responses: Phrases[] = ["dont_understand_forward"];
        for (var item in responses)
        {
            #say(item, repeatMode: "ignore");
        }
        set $status = "DontUnderstandHangup";
        set $serviceStatus = "Done";
        exit;
    }
}
