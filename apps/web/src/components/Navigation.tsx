import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Calculator, BarChart3, Activity, Download } from 'lucide-react';

const Navigation = () => {
  const [isScrolled, setIsScrolled] = useState(false);
  const [activeTime, setActiveTime] = useState(new Date());

  useEffect(() => {
    const handleScroll = () => {
      setIsScrolled(window.scrollY > 50);
    };

    window.addEventListener('scroll', handleScroll);
    return () => window.removeEventListener('scroll', handleScroll);
  }, []);

  useEffect(() => {
    const timer = setInterval(() => {
      setActiveTime(new Date());
    }, 1000);
    return () => clearInterval(timer);
  }, []);

  const navItems = [
    { label: 'LIVE DEMO', href: '#live-demo', icon: Activity },
    { label: 'FEATURES', href: '#features', icon: BarChart3 },
    { label: 'PRICING', href: '#pricing', icon: Calculator },
  ];

  return (
    <motion.nav 
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-500`}
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ type: "spring", stiffness: 100 }}
    >
      <div className="w-full px-4 py-4">
        <div className={`
          max-w-7xl mx-auto backdrop-blur-md border rounded-2xl transition-all duration-500
          ${isScrolled 
            ? 'bg-gray-900/90 border-gray-700 shadow-2xl shadow-black/50' 
            : 'bg-black/50 border-green-500/20'
          }
        `}>
          <div className="flex items-center justify-between px-6 py-4">
            {/* Logo */}
            <motion.div 
              className="flex items-center space-x-3"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <div className="relative">
                <div className="w-10 h-10 bg-gradient-to-br from-green-400 to-emerald-500 rounded-xl flex items-center justify-center">
                  <Calculator className="w-6 h-6 text-black" />
                </div>
                <motion.div 
                  className="absolute -top-1 -right-1 w-3 h-3 bg-green-400 rounded-full"
                  animate={{ scale: [1, 1.2, 1] }}
                  transition={{ duration: 2, repeat: Infinity }}
                />
              </div>
              <div className="hidden sm:block">
                <div className="text-lg font-bold text-white">Kelly Stakes</div>
                <div className="text-xs text-gray-500 font-mono">
                  {activeTime.toLocaleTimeString('en-US', { hour12: false })}
                </div>
              </div>
            </motion.div>

            {/* Center Navigation */}
            <div className="hidden lg:flex items-center gap-1">
              {navItems.map((item, i) => (
                <motion.a
                  key={i}
                  href={item.href}
                  className="group relative px-3 py-2 text-sm font-mono text-gray-400 hover:text-green-400 transition-colors"
                  whileHover={{ y: -2 }}
                  whileTap={{ scale: 0.95 }}
                >
                  <div className="flex items-center gap-2">
                    <item.icon className="w-4 h-4" />
                    <span className="hidden xl:inline">{item.label}</span>
                  </div>
                  <motion.div 
                    className="absolute bottom-0 left-0 right-0 h-0.5 bg-green-400"
                    initial={{ scaleX: 0 }}
                    whileHover={{ scaleX: 1 }}
                    transition={{ duration: 0.3 }}
                  />
                </motion.a>
              ))}
            </div>

            {/* Status Indicators - Only show on XL screens */}
            <div className="hidden xl:flex items-center gap-4">
              <div className="flex items-center gap-2">
                <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
                <span className="text-xs text-gray-500 font-mono">MARKET OPEN</span>
              </div>
              <div className="h-6 w-px bg-gray-700" />
              <span className="text-xs text-gray-500 font-mono">v2.0.1</span>
            </div>

            {/* CTA Button */}
            <motion.a
              href="https://apps.apple.com/app/kelly-stakes"
              className="relative group"
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <div className="relative px-6 py-3 bg-gradient-to-r from-green-400 to-emerald-400 rounded-xl overflow-hidden">
                <div className="relative z-10 flex items-center gap-2 text-black font-bold">
                  <Download className="w-4 h-4" />
                  <span>Download Free</span>
                </div>
                <motion.div 
                  className="absolute inset-0 bg-white"
                  initial={{ x: "-100%" }}
                  whileHover={{ x: 0 }}
                  transition={{ duration: 0.3 }}
                />
              </div>
              
              {/* Glow effect */}
              <motion.div 
                className="absolute -inset-1 bg-gradient-to-r from-green-400 to-emerald-400 rounded-xl opacity-0 group-hover:opacity-50 blur-xl transition-opacity"
                animate={{ scale: [1, 1.1, 1] }}
                transition={{ duration: 2, repeat: Infinity }}
              />
            </motion.a>
          </div>
        </div>
      </div>
    </motion.nav>
  );
};

export default Navigation;