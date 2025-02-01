import ballerina/http;
import ballerina/sql;
import ballerina/time;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;

type TeamLead record {
    readonly int id;
    string name;
};

type FeedBack record {
    readonly int id;
    @sql:Column {name: "employee_name"}
    string employeeName;

    @sql:Column {name: "team_lead"}
    string teamLead;

    string feedback;
    float rating;

    @sql:Column {name: "submitted_date"}
    time:Date submittedDate;
};

table<TeamLead> key(id) teamleads = table [
    {id: 1, name: "Pathum Perera"},
    {id: 2, name: "Kavindu Fernando"},
    {id: 3, name: "Sunil Perera"},
    {id: 4, name: "Ravindu Weerasinghe"},
    {id: 5, name: "Isuru Jayawardhana"}

];

type ErrorDetails record {
    string message;
    string details;
    time:Utc timeStamp;
};

type UserNotFound record {|
    *http:NotFound;
    ErrorDetails body;

|};

type NewFeedback record {
    string employeeName;
    string teamLead;
    string feedback;
    float rating;

};

mysql:Client feedback = check new ("localhost",
    user = "root",
    password = "Sahasra2001!",
    database = "teamlead_feedback",
    port = 3306
);

@http:ServiceConfig {
    cors: {
        allowOrigins: ["http://localhost:5173"],
        allowCredentials: true,
        allowMethods: ["GET", "POST", "OPTIONS"],
        allowHeaders: ["Content-Type", "Authorization"],
        exposeHeaders: ["X-CUSTOM-HEADER"],
        maxAge: 86400
        }
}

service /feedback on new http:Listener(9090) {

    resource function get feedbacks() returns FeedBack[]|error? {
        stream<FeedBack, sql:Error?> feedbackStream = feedback->query(`SELECT * FROM feedback`);
        return from FeedBack feedback in feedbackStream
            select feedback;
    }

    resource function get teamLeads() returns TeamLead[]|error? {
        return teamleads.toArray();
    }

    resource function post submitFeedback(NewFeedback newFeedback, http:Request req) returns http:Created|error {
        _ = check feedback->execute(`
        INSERT INTO feedback(employee_name,team_lead,feedback,rating,submitted_date) 
        VALUES (${newFeedback.employeeName},${newFeedback.teamLead},${newFeedback.feedback},${newFeedback.rating},CURRENT_DATE);`
        );
        return http:CREATED;

    }
}
