import React from 'react';
import { Calculator, Mail, Shield, FileText, HelpCircle } from 'lucide-react';

const Footer = () => {
  return (
    <footer className="bg-gray-900 border-t border-gray-800">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid md:grid-cols-4 gap-8">
          <div className="md:col-span-2">
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-10 h-10 bg-gradient-to-br from-green-500 to-green-600 rounded-lg flex items-center justify-center">
                <Calculator className="w-6 h-6 text-white" />
              </div>
              <span className="text-2xl font-bold text-white">Kelly Stakes</span>
            </div>
            
            <p className="text-gray-400 mb-6 max-w-md">
              Professional bankroll management using the Kelly Criterion mathematical formula. 
              Calculate optimal position sizes for sports betting, trading, and investment decisions.
            </p>
            
            <div className="flex items-center space-x-2 text-sm text-gray-500">
              <Shield className="w-4 h-4" />
              <span>100% Private • No Data Collection • Made for iOS</span>
            </div>
          </div>

          <div>
            <h3 className="text-white font-semibold mb-4">Legal</h3>
            <ul className="space-y-3">
              <li>
                <a 
                  href="/privacy" 
                  className="text-gray-400 hover:text-green-500 transition-colors duration-200 flex items-center space-x-2"
                >
                  <Shield className="w-4 h-4" />
                  <span>Privacy Policy</span>
                </a>
              </li>
              <li>
                <a 
                  href="/terms" 
                  className="text-gray-400 hover:text-green-500 transition-colors duration-200 flex items-center space-x-2"
                >
                  <FileText className="w-4 h-4" />
                  <span>Terms of Service</span>
                </a>
              </li>
            </ul>
          </div>

          <div>
            <h3 className="text-white font-semibold mb-4">Support</h3>
            <ul className="space-y-3">
              <li>
                <a 
                  href="mailto:kellystakesapp@gmail.com" 
                  className="text-gray-400 hover:text-green-500 transition-colors duration-200 flex items-center space-x-2"
                >
                  <Mail className="w-4 h-4" />
                  <span>Contact Support</span>
                </a>
              </li>
              <li>
                <a 
                  href="/help" 
                  className="text-gray-400 hover:text-green-500 transition-colors duration-200 flex items-center space-x-2"
                >
                  <HelpCircle className="w-4 h-4" />
                  <span>Help Center</span>
                </a>
              </li>
              <li>
                <a 
                  href="#faq" 
                  className="text-gray-400 hover:text-green-500 transition-colors duration-200"
                >
                  FAQ
                </a>
              </li>
              <li>
                <a 
                  href="mailto:kellystakesapp@gmail.com" 
                  className="text-gray-400 hover:text-green-500 transition-colors duration-200"
                >
                  Educational Resources
                </a>
              </li>
            </ul>
          </div>
        </div>

        <div className="border-t border-gray-800 mt-12 pt-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <div className="text-gray-500 text-sm mb-4 md:mb-0">
              © 2025 Kelly Stakes. All rights reserved.
            </div>
            
            <div className="text-gray-500 text-sm">
              Kelly Stakes is an educational and analytical tool. Always gamble responsibly and within your means.
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;