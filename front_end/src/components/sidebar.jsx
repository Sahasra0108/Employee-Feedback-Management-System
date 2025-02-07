import { FiEdit, FiList, FiLogOut } from "react-icons/fi";
import { Link } from 'react-router-dom';

const Sidebar = () => {
  return (
    <div className="w-64 h-screen bg-blue-900 text-white fixed left-0 top-0 p-5">
      
       

       
      <ul>
        <li className="flex items-center p-3 hover:bg-blue-700 rounded-md cursor-pointer">
          <FiEdit size={20} />
          <Link to="/form" className="ml-4">Feedback Form</Link>
        </li>
        <li className="flex items-center p-3 hover:bg-blue-700 rounded-md cursor-pointer mt-4">
          <FiList size={20} />
          <Link to="/feedback" className="ml-4">Feedback List</Link>
        </li>
        <li className="flex items-center p-3 hover:bg-blue-700 rounded-md cursor-pointer mt-4">
          <FiLogOut size={20} />
          <span className="ml-4">Logout</span>
        </li>
      </ul>
    </div>
  );
};

export default Sidebar;
