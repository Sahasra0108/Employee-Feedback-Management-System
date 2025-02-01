import './App.css'
import Form from './components/form'
import Sidebar from './components/sidebar';
import FeedbackTable from './components/table';
import FeedbackPage from './pages/feedbackformpage';
import Loginpage from './pages/login';
import Feedbacklist from './pages/feedbacklist';
import { BrowserRouter as Router, Route, Routes,useLocation } from 'react-router-dom';

function App() {
  const location=useLocation();
  return (
    <>
      
      {location.pathname !== "/" && <Sidebar />}
      <Routes>
        <Route path="/" element={<Loginpage/>}/> 
        <Route path="/feedback" element={<Feedbacklist/>}/> 
        <Route path="/form" element={<FeedbackPage/>}/>   
    </Routes>
  
    </>

  )
}

export default function Appwrapper(){
  return(
    <Router>
      <App/>
    </Router>
  )
}

 
