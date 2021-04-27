while(alive) {
    situation = body.observeSurroundings();
    if(situation.requiresAction() == true) {
        action = makeDecision(situation);
        outcome = null;

        # check that the situation still needs action and an action is available
        if (situation.requiresAction() == true && action != null) {
            outcome = body.act(action);
        }

        # Add the experience to memory so it can be used for future decisions
        memory.addExperience(situation, outcome);
    }
}

def makeDecision(situation){
    urgency = situation.getUrgency();

    # length of previous experience list depends on urgency
    previousExperience = memory.findRelated(situation, urgency); 

    # can be effected very quickly and intensely -- hormones, pain, breakfast etc... 
    currentPhysicalState = body.getProperties(); 

    feelingForSituation = evaluateSituation(previousExperience, currentPhysicalState);
    action = createActionForSituation(situation, feelingForSituation, currentPhysicalState)
}

def evaluateSituation(experiences, currentPhysicalState) {
    situationFeelings = [];
    for experience in experiences({
        # Algorithm scores each feeling and experience based on multiple factors
        feelingForExperience = mind.evaluate(experience.getSituation, experience.getAction, experience.getOutcome, currentPhysicalState); 
        situationFeelings.add(feelingForExperience);
    })
    # Algorithm aggregates and compares all feelings and experiences and returns an overall scored feeling
    feelingForSituation = mind.evaluate(situationFeelings); 
    return feelingForSituation;
}

def createActionForSituation(situation, feelings, physicalState) {
    action = null;
    while (action == null) {

        # Algorithm creates action from situation, feelings, phiscalState
        # A level of exploratory randomness will be factored in based on the situation (urgency, importance), feeling confidence score, and mental state
        possibleAction = mind.createAction(situation, feelings, physicalState);

        # Situation urgency and importance are two main factors of outcome certainty
        possibleOutcome = mind.simulateOutcome(action, situation)

        # actionIsAppropriateForSituation evaluates the outcome and action based on situation
        if (actionIsAppropriateForSituation(possibleAction, possibleOutcome, situation) == true) {
            return possibleAction;
        }
    }
}