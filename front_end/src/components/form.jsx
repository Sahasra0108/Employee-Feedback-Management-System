import { useEffect, useState } from "react";
import ReactStars from "react-stars";
import { getTeamLeads, submitFeedback } from "../api/api";
import Swal from "sweetalert2";

function Form() {
  const [formData, setFormdata] = useState({
    teamLead: "",
    feedback: "",
    rating: 0.0,
    employeeName: "sachini",
  });

  const [teamLeads, setTeamLeads] = useState([]);
  const [errors, setErrors] = useState({});

  useEffect(() => {
    getTeamLeads()
      .then((data) => setTeamLeads(data))
      .catch((error) => console.error(error));
  });

  const handleChange = (e) => {
    setFormdata({
      ...formData,
      [e.target.name]: e.target.value,
    });

    setErrors((prevErrors) => ({
      ...prevErrors,
      [e.target.name]: e.target.value.trim() ? "" : prevErrors[name],
    }));
  };

  const handleRatingChange = (newRating) => {
    setFormdata({
      ...formData,
      rating: newRating,
    });

    setErrors((prevErrors) => ({
      ...prevErrors,
      rating: newRating > 0 ? "" : prevErrors.rating,
    }));
  };

  const validateForm = () => {
    let newErrors = {};
    if (!formData.teamLead) newErrors.team_lead = "Please select a team lead.";
    if (!formData.feedback.trim()) newErrors.feedback = "Feedback is required.";
    if (formData.rating === 0) newErrors.rating = "Please provide a rating.";

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validateForm()) return;
    try {
      await submitFeedback(formData);
      Swal.fire({
        icon: "success",
        title: "Feedback submitted succesfully!",
      });
      setFormdata({
        teamLead: "",
        feedback: "",
        rating: 0.0,
        employeeName: "sachini",
      });

      setErrors({});
    } catch {
      Swal.fire({
        icon: "error",
        title: "Please try again!",
      });
    }
  };

  return (
    
      <form className="form-container" onSubmit={handleSubmit}>
        <label htmlFor="teamLead">Team Lead :</label>
        {errors.teamLead && <p className="error">{errors.teamLead}</p>}

        <select
          id="teamLead"
          value={formData.teamLead}
          onChange={handleChange}
          name="teamLead"
        >
          <option>Select a team lead</option>
          {teamLeads.map((lead) => (
            <option key={lead.id} value={lead.name}>
              {lead.name}
            </option>
          ))}
        </select>
        <label htmlFor="feedback">Feedback:</label>
        {errors.feedback && <p className="error">{errors.feedback}</p>}
        <textarea
          name="feedback"
          value={formData.feedback}
          onChange={handleChange}
        />

        <label htmlFor="rating">Rating:</label>
        {errors.rating && <p className="error">{errors.rating}</p>}
        <ReactStars
          count={5}
          value={formData.rating}
          onChange={handleRatingChange}
          size={30}
          color={"#ffd700"}
        />

        <button
          type="submit"
          className="w-[300px] bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-bold"
        >
          Submit Feedback
        </button>
      </form>
    
  );
}

export default Form;
