import axios from "axios";

const API_BASE_URL="http://localhost:9090/feedback";

export const submitFeedback = async (feedbackData) =>{
    try{
        const response=await axios.post(`${API_BASE_URL}/submitFeedback`,feedbackData);
        return response.data;
    }
    catch(error){
        console.error("Error submitting feedback:", error);
        throw error;
    }
};

export const getTeamLeads = async() =>{
    try{
        const response= await axios.get(`${API_BASE_URL}/teamLeads`);
        return response.data;
    } catch(error){
        console.error("Error submitting feedback:", error);
        throw error;
    }
}

export const getfeedbacks = async() =>{
    try{
        const response= await axios.get(`${API_BASE_URL}/feedbacks`);
        return response.data;
    } catch(error){
        console.error("Error submitting feedback:", error);
        throw error;
    }
}
