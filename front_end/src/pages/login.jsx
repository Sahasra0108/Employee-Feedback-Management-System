import { useState } from "react";
import { useNavigate } from "react-router-dom";
import feedback from "../assests/feedback2.png";
import Swal from "sweetalert2";

function Loginpage() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();

    const testUser = {
      username: "employee@gmail.com",
      password: "pass123",
    };

    if (email === testUser.username && password === testUser.password) {
      setError(null);
      Swal.fire({
        icon: "success",
        title: "Login successful!",
      });
      navigate("/feedback");
    } else {
      setError("Invalid email or password.");
      Swal.fire({
        icon: "error",
        title: "Invalid username or password",
      });
    }
  };
  return (
    <div className="flex w-full h-screen">
      <div className="grid grid-cols-1 m-auto md:grid-cols-2 h-[500px] shadow-lg shadow-gray-600 sm:max-w-[900px]">
        <div className="hidden  md:block  bg-blue-500">
          <img className="w-full pt-10" src={feedback} alt="feedback image" />
        </div>

        <div className="flex flex-col justify-around p-16 ">
          <form onSubmit={handleSubmit}>
            <h1 className="text-[45px] font-bold text-center mb-6 text-blue-700">
              Login
            </h1>

            <h6 className="mb-2 text-blue-800 font-medium">
              Please enter your login details to sign in.
            </h6>
            <div className="flex flex-col gap-2">
              <input
                className="logininput"
                type="email"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                placeholder="User email"
              />
              <input
                className="logininput"
                type="password"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                placeholder="Password"
              />
            </div>
            <button className="loginbutton" type="submit">
              Login
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}

export default Loginpage;
