import ballerina/constraint;
import ballerina/http;
import ballerina/openapi;
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
    @constraint:String {
        minLength: {
            value: 1,
            message: "Team lead name is required."
        }

        }

    string teamLead;

    @constraint:String {
        minLength: {
            value: 1,
            message: "Feedback is required."
        }
    }
    string feedback;

    @constraint:Float {
        minValue: {
            value: 0.5,
            message: "Rating is required."
        }
    }
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

    @openapi:ResourceInfo {
        operationId: "retriveAllFeedbacks",
        summary: "API for retrive all feedbacks in the database",
        tags: ["feedbacks"],
        examples: {
            "response": {
                "200": {
                    "examples": {
                        "application/json": {
                            "feedback01": {
                                "value": {
                                    "id": 1,
                                    "employeeName": "sachini",
                                    "teamLead": "Pathum Perera",
                                    "feedback": "fef",
                                    "rating": 2.5,
                                    "submittedDate": {
                                        "year": 2025,
                                        "month": 2,
                                        "day": 1
                                    }

                                }
                            }
                        }

                    }
                
                }

            }
        }
    }

    resource function get feedbacks() returns FeedBack[]|ErrorDetails|error {
        stream<FeedBack, sql:Error?> feedbackStream = feedback->query(`SELECT * FROM feedback`);

        return from FeedBack feedback in feedbackStream
            select feedback;
    }

    @openapi:ResourceInfo {
        operationId: "retriveAllFeedbacks",
        summary: "API for retrive all feedbacks in the database",
        tags: ["feedbacks"],
        examples: {
            "response": {
                "200": {
                    "examples": {
                        "application/json": {
                            "feedback01": {
                                "value": {
                                    "id": 1,
                                    "name": "Pathum Perera"
                                
                                }
                            }

                        }
                    
                    }

                }
            }
        }
    }

    resource function get teamLeads() returns TeamLead[]|error? {
        return teamleads.toArray();
    }

    @openapi:ResourceInfo {
         
        operationId: "submitFeedbacks",
        summary: "API for retrive submit feedbacks to the database",
        tags: ["feedbacks"],
        
        examples: {
            "requestBody": {
                "application/json": {
                    "validFeedback": {
                        "value": {
                            "employeeName": "Nimesh Perera",
                            "teamLead": "Pathum Perera",
                            "feedback": "Great support and guidance throughout the project.",
                            "rating": 5
                        }
                    },
                    "invalidFeedback": {
                        "value": {
                            "employeeName": "Janith Silva",
                            "teamLead": "",
                            "feedback": "Needs improvement in communication.",
                            "rating": 3
                        }
                    }
                }
            },
    
        
            "response": {
                "201": {
                    "examples": {
                        "application/json": {
                            "message": {
                                "value": {
                                    "message": "Feedback submitted successfully."
                                
                                }
                            }

                        }

                    }
                },
                "400": {
                    "examples": {
                        "application/json": {
                            "message": {
                                "value": {
                                    "error": "Employee name is required."
                                }
                            }
                        }
                    }
                }

            }
        }
        
    }

    resource function post submitFeedback(NewFeedback newFeedback, http:Request req) returns http:Created|http:BadRequest|error {
        
        _ = check feedback->execute(`
        INSERT INTO feedback(employee_name,team_lead,feedback,rating,submitted_date) 
        VALUES (${newFeedback.employeeName},${newFeedback.teamLead},${newFeedback.feedback},${newFeedback.rating},CURRENT_DATE);`
        );
        return http:CREATED;

    }
}
