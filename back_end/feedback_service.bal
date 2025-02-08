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
                
                },
                "500": {
                    "examples": {
                        "application/json": {
                            "errorResponse": {
                                "value": {
                                    "message": "An internal server error occurred.",
                                    "details": "Error details message here",
                                    "timeStamp": "2025-02-08T11:44:39.670979100Z"

                                }
                            }
                        }

                    }
                
                }

            }
        }
    }

    resource function get feedbacks() returns FeedBack[]|http:Response|sql:Error {
        stream<FeedBack, sql:Error?>|error result = trap feedback->query(`SELECT * FROM feedback`);

        if result is error {
            ErrorDetails errorDetails = {
                message: "An internal server error occurred.",
                details: result.message(),
                timeStamp: time:utcNow()
            };

            json errorDetailsJson = errorDetails.toJson();
            http:Response response = new;
            response.statusCode = 500;
            response.setJsonPayload(errorDetailsJson);
            return response;
        }

        return check from FeedBack feedback in result
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

                },
                "500": {
                    "examples": {
                        "application/json": {
                            "errorResponse": {
                                "value": {
                                    "message": "An internal server error occurred.",
                                    "details": "Error details message here",
                                    "timeStamp": "2025-02-08T11:44:39.670979100Z"
                                
                                }
                            }

                        }
                    
                    }

                }

            }
        }
    }

    resource function get teamLeads() returns TeamLead[]|http:Response {
        TeamLead[]|error result = trap teamleads.toArray();

        if result is error {
            ErrorDetails errorDetails = {
                message: "An internal server error occurred.",
                details: result.message(),
                timeStamp: time:utcNow()
            };

            json errorDetailsJson = errorDetails.toJson();

            http:Response response = new;
            response.statusCode = 500;
            response.setJsonPayload(errorDetailsJson);
            return response;

        }
        return result;
    }

    @openapi:ResourceInfo {
        operationId: "submitFeedbacks",
        summary: "API for submit feedbacks to the database",
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
                "200": {
                    "examples": {
                        "application/json": {
                            "feedback01": {
                                "value": {
                                    "message": "feed back submitted"
                                
                                }
                            }

                        }
                    
                    }
                },
                "500": {
                    "examples": {
                        "application/json": {
                            "errorResponse": {
                                "value": {
                                    "message": "An internal server error occurred.",
                                    "details": "Error details message here",
                                    "timeStamp": "2025-02-08T11:44:39.670979100Z"
                                
                                }
                            }

                        }
                    
                    }

                },
                "400": {
                    "examples": {
                        "application/json": {
                            "missingTeamLead": {
                                "value": {
                                    "timestamp": "2025-02-08T14:52:46.778243Z",
                                    "status": 400,
                                    "reason": "Bad Request",
                                    "message": "payload validation failed: Team lead name is required.",
                                    "path": "/feedback/submitFeedback",
                                    "method": "POST"
                                
                                }
                            },
                            "missingFeedback": {
                                "value": {
                                    "timestamp": "2025-02-08T14:52:46.778243Z",
                                    "status": 400,
                                    "reason": "Bad Request",
                                    "message": "payload validation failed: Feedback is required.",
                                    "path": "/feedback/submitFeedback",
                                    "method": "POST"
                                
                                }
                            },
                            "missingRating": {
                                "value": {
                                    "timestamp": "2025-02-08T14:52:46.778243Z",
                                    "status": 400,
                                    "reason": "Bad Request",
                                    "message": "payload validation failed: Rating is required.",
                                    "path": "/feedback/submitFeedback",
                                    "method": "POST"
                                
                                }
                            }

                        }
                    
                    }

                }
            
            }

        }
    
    }

    resource function post submitFeedback(NewFeedback newFeedback, http:Request req)
    returns http:Response|error {
        do {

            _ = check feedback->execute(`
        INSERT INTO feedback(employee_name, team_lead, feedback, rating, submitted_date) 
        VALUES (${newFeedback.employeeName}, ${newFeedback.teamLead}, ${newFeedback.feedback}, ${newFeedback.rating}, CURRENT_DATE);
    `);
        }
        on fail var err {

            ErrorDetails errorDetails = {
                message: "An internal server error occurred.",
                details: err.message(),
                timeStamp: time:utcNow()
            };

            json errorDetailsJson = errorDetails.toJson();

            http:Response response = new;
            response.statusCode = 500;
            response.setJsonPayload(errorDetailsJson);
            return response;
        }

        http:Response response = new;
        response.statusCode = 200;
        json payload = {
            "message": "feed back submitted successfully"
        };
        response.setJsonPayload(payload);

        return response;
    }

}
