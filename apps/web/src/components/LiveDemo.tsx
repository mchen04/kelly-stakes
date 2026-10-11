import { americanToDecimal, kellyFraction } from '@kelly-stakes/kelly';
import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { 
  Play, 
  DollarSign, 
  Percent, 
  TrendingUp, 
  AlertCircle,
  Zap,
  ChevronRight,
  BarChart3
} from 'lucide-react';

const LiveDemo = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });
  const [bankroll, setBankroll] = useState(10000);
  const [givenOdds, setGivenOdds] = useState('+150'); // American odds from sportsbook
  const [trueOdds, setTrueOdds] = useState('-110'); // Your estimated true odds
  const [kellyMultiplier, setKellyMultiplier] = useState(0.25); // Fractional Kelly (25%)
  const [isCalculating, setIsCalculating] = useState(false);
  
  // Kelly calculation
  const calculateKelly = () => {
    const givenDecimal = americanToDecimal(givenOdds);
    const trueDecimal = americanToDecimal(trueOdds);
    return kellyFraction(givenDecimal, 1 / trueDecimal) * 100;
  };

  const fullKellyPercentage = calculateKelly();
  const kellyPercentage = fullKellyPercentage * kellyMultiplier;
  const betSize = Math.round(bankroll * (kellyPercentage / 100));

  const scenarios = [
    { sport: 'NFL', team1: 'Chiefs', team2: 'Bills', givenOdds: '+115', trueOdds: '-108', favorite: 1 },
    { sport: 'NBA', team1: 'Lakers', team2: 'Celtics', givenOdds: '-118', trueOdds: '-138', favorite: 0 },
    { sport: 'UFC', team1: 'Fighter A', team2: 'Fighter B', givenOdds: '+145', trueOdds: '+122', favorite: 1 },
  ];

  const [activeScenario, setActiveScenario] = useState(0);

  const handleScenarioClick = (index: number) => {
    setIsCalculating(true);
    setActiveScenario(index);
    const scenario = scenarios[index];
    
    setTimeout(() => {
      setGivenOdds(scenario.givenOdds);
      setTrueOdds(scenario.trueOdds);
      setIsCalculating(false);
    }, 500);
  };

  return (
    <section id="live-demo" className="py-32 bg-black relative overflow-hidden">
      {/* Animated background */}
      <div className="absolute inset-0">
        <div className="absolute inset-0 opacity-10">
          {[...Array(20)].map((_, i) => (
            <motion.div
              key={i}
              className="absolute w-px bg-gradient-to-b from-transparent via-green-400/50 to-transparent"
              style={{ left: `${i * 5}%`, height: '200%', top: '-50%' }}
              animate={{ y: ['0%', '100%'] }}
              transition={{ duration: 20 + i * 2, repeat: Infinity, ease: 'linear' }}
            />
          ))}
        </div>
      </div>

      <div className="max-w-7xl mx-auto px-4 relative z-10">
        <motion.div 
          ref={ref}
          className="text-center mb-16"
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
        >
          <motion.div 
            className="inline-flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/30 rounded-full mb-6"
            initial={{ scale: 0 }}
            animate={inView ? { scale: 1 } : {}}
            transition={{ delay: 0.2, type: "spring" }}
          >
            <Play className="w-4 h-4 text-green-400" />
            <span className="text-green-400 text-sm font-mono">INTERACTIVE DEMO</span>
          </motion.div>

          <h2 className="text-4xl sm:text-5xl font-bold text-white mb-6">
            <span className="block">See Kelly Criterion</span>
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-emerald-400">
              In Action
            </span>
          </h2>
          
          <p className="text-xl text-gray-400 max-w-3xl mx-auto">
            Experience real-time position sizing. Adjust parameters and watch the mathematics work.
          </p>
        </motion.div>

        <div className="grid lg:grid-cols-2 gap-12">
          {/* Left - Interactive Controls */}
          <motion.div
            initial={{ opacity: 0, x: -50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ delay: 0.4 }}
            className="space-y-6"
          >
            {/* Scenario Selector */}
            <div className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-2xl p-6">
              <h3 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
                <BarChart3 className="w-5 h-5 text-green-400" />
                Select Betting Scenario
              </h3>
              
              <div className="space-y-3">
                {scenarios.map((scenario, index) => (
                  <motion.button
                    key={index}
                    className={`w-full p-4 rounded-xl border transition-all ${
                      activeScenario === index 
                        ? 'bg-green-500/10 border-green-500/50' 
                        : 'bg-black/30 border-gray-700 hover:border-gray-600'
                    }`}
                    onClick={() => handleScenarioClick(index)}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="flex items-center justify-between">
                      <div className="flex items-center gap-3">
                        <div className={`px-2 py-1 rounded text-xs font-mono ${
                          scenario.sport === 'NFL' ? 'bg-blue-500/20 text-blue-400' :
                          scenario.sport === 'NBA' ? 'bg-orange-500/20 text-orange-400' :
                          'bg-red-500/20 text-red-400'
                        }`}>
                          {scenario.sport}
                        </div>
                        <span className="text-white font-medium">
                          {scenario.team1} vs {scenario.team2}
                        </span>
                      </div>
                      <div className="flex items-center gap-2">
                        <span className="text-gray-400 text-sm">{scenario.givenOdds}</span>
                        <ChevronRight className={`w-4 h-4 transition-colors ${
                          activeScenario === index ? 'text-green-400' : 'text-gray-600'
                        }`} />
                      </div>
                    </div>
                  </motion.button>
                ))}
              </div>
            </div>

            {/* Parameter Controls */}
            <div className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-2xl p-6">
              <h3 className="text-lg font-bold text-white mb-6">Adjust Parameters</h3>
              
              <div className="space-y-6">
                {/* Bankroll */}
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <label className="text-sm text-gray-400 flex items-center gap-2">
                      <DollarSign className="w-4 h-4" />
                      Bankroll
                    </label>
                    <span className="text-white font-mono">${bankroll.toLocaleString()}</span>
                  </div>
                  <input
                    type="range"
                    min="1000"
                    max="50000"
                    step="1000"
                    value={bankroll}
                    onChange={(e) => setBankroll(Number(e.target.value))}
                    className="w-full h-2 bg-gray-800 rounded-lg appearance-none cursor-pointer"
                    style={{
                      background: `linear-gradient(to right, rgb(74, 222, 128) 0%, rgb(74, 222, 128) ${((bankroll - 1000) / 49000) * 100}%, rgb(31, 41, 55) ${((bankroll - 1000) / 49000) * 100}%, rgb(31, 41, 55) 100%)`
                    }}
                  />
                </div>

                {/* True Odds (Your Estimate) */}
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <label className="text-sm text-gray-400 flex items-center gap-2">
                      <Percent className="w-4 h-4" />
                      Your True Odds
                    </label>
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => setTrueOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${num + 5}`;
                        return `+${Math.max(100, num - 5)}`;
                      })}
                      className="px-3 py-2 bg-gray-700 hover:bg-gray-600 rounded text-gray-300"
                    >
                      -
                    </button>
                    <input
                      type="text"
                      value={trueOdds}
                      onChange={(e) => {
                        const val = e.target.value;
                        if (val.match(/^[+-]?\d*$/)) setTrueOdds(val);
                      }}
                      className="flex-1 bg-black/50 border border-gray-700 rounded px-3 py-2 text-center font-mono text-green-400"
                    />
                    <button
                      onClick={() => setTrueOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${Math.min(-100, num + 5)}`;
                        return `+${num + 5}`;
                      })}
                      className="px-3 py-2 bg-gray-700 hover:bg-gray-600 rounded text-gray-300"
                    >
                      +
                    </button>
                  </div>
                  <div className="text-xs text-gray-500 text-center mt-1">
                    Implied: {(1 / americanToDecimal(trueOdds) * 100).toFixed(1)}%
                  </div>
                </div>

                {/* Given Odds (Sportsbook) */}
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <label className="text-sm text-gray-400 flex items-center gap-2">
                      <TrendingUp className="w-4 h-4" />
                      Given Odds
                    </label>
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => setGivenOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${num + 5}`;
                        return `+${Math.max(100, num - 5)}`;
                      })}
                      className="px-3 py-2 bg-gray-700 hover:bg-gray-600 rounded text-gray-300"
                    >
                      -
                    </button>
                    <input
                      type="text"
                      value={givenOdds}
                      onChange={(e) => {
                        const val = e.target.value;
                        if (val.match(/^[+-]?\d*$/)) setGivenOdds(val);
                      }}
                      className="flex-1 bg-black/50 border border-gray-700 rounded px-3 py-2 text-center font-mono text-green-400"
                    />
                    <button
                      onClick={() => setGivenOdds(prev => {
                        const num = parseInt(prev);
                        if (num < 0) return `${Math.min(-100, num + 5)}`;
                        return `+${num + 5}`;
                      })}
                      className="px-3 py-2 bg-gray-700 hover:bg-gray-600 rounded text-gray-300"
                    >
                      +
                    </button>
                  </div>
                  <div className="text-xs text-gray-500 text-center mt-1">
                    Decimal: {americanToDecimal(givenOdds).toFixed(2)}
                  </div>
                </div>

                {/* Kelly Multiplier */}
                <div>
                  <div className="flex items-center justify-between mb-2">
                    <label className="text-sm text-gray-400 flex items-center gap-2">
                      <Percent className="w-4 h-4" />
                      Kelly Fraction
                    </label>
                    <span className="text-white font-mono">{(kellyMultiplier * 100).toFixed(0)}%</span>
                  </div>
                  <input
                    type="range"
                    min="0.1"
                    max="1"
                    step="0.05"
                    value={kellyMultiplier}
                    onChange={(e) => setKellyMultiplier(Number(e.target.value))}
                    className="w-full h-2 bg-gray-800 rounded-lg appearance-none cursor-pointer"
                    style={{
                      background: `linear-gradient(to right, rgb(74, 222, 128) 0%, rgb(74, 222, 128) ${kellyMultiplier * 100}%, rgb(31, 41, 55) ${kellyMultiplier * 100}%, rgb(31, 41, 55) 100%)`
                    }}
                  />
                  <div className="flex justify-between text-xs text-gray-500 mt-1">
                    <span>Conservative (10%)</span>
                    <span>Full Kelly (100%)</span>
                  </div>
                </div>
              </div>
            </div>
          </motion.div>

          {/* Right - Results Display */}
          <motion.div
            initial={{ opacity: 0, x: 50 }}
            animate={inView ? { opacity: 1, x: 0 } : {}}
            transition={{ delay: 0.6 }}
            className="space-y-6"
          >
            {/* Main Result */}
            <div className="bg-gradient-to-br from-gray-900 to-gray-800 border border-green-500/30 rounded-2xl p-8 relative overflow-hidden">
              <motion.div
                className="absolute inset-0 bg-gradient-to-br from-green-500/10 to-transparent"
                animate={{ opacity: isCalculating ? [0.5, 1, 0.5] : 0 }}
                transition={{ duration: 1, repeat: Infinity }}
              />
              
              <div className="relative z-10">
                <div className="flex items-center justify-between mb-6">
                  <h3 className="text-xl font-bold text-white">Kelly Calculation</h3>
                  <motion.div 
                    className="flex items-center gap-2"
                    animate={{ opacity: isCalculating ? 1 : 0 }}
                  >
                    <Zap className="w-4 h-4 text-green-400 animate-pulse" />
                    <span className="text-xs text-green-400">CALCULATING</span>
                  </motion.div>
                </div>

                <div className="text-center py-8">
                  <div className="text-6xl font-mono font-bold text-green-400 mb-2">
                    ${betSize.toLocaleString()}
                  </div>
                  <div className="text-xl text-gray-300 mb-4">
                    Optimal Bet Size
                  </div>
                  <div className="space-y-2">
                    <div className="inline-flex items-center gap-2 px-4 py-2 bg-black/50 rounded-full">
                      <div className="w-2 h-2 rounded-full bg-green-400" />
                      <span className="text-sm font-mono text-green-400">
                        {kellyPercentage.toFixed(2)}% of bankroll
                      </span>
                    </div>
                    <div className="text-xs text-gray-500">
                      Full Kelly: {fullKellyPercentage.toFixed(2)}% × {(kellyMultiplier * 100).toFixed(0)}% = {kellyPercentage.toFixed(2)}%
                    </div>
                  </div>
                </div>

                {/* Risk Indicator */}
                <div className="mt-6 p-4 bg-black/30 rounded-xl">
                  <div className="flex items-center justify-between mb-2">
                    <span className="text-sm text-gray-400">Risk Level</span>
                    <span className={`text-sm font-mono ${
                      kellyPercentage > 25 ? 'text-red-400' : 
                      kellyPercentage > 15 ? 'text-yellow-400' : 
                      'text-green-400'
                    }`}>
                      {kellyPercentage > 25 ? 'HIGH' : kellyPercentage > 15 ? 'MEDIUM' : 'LOW'}
                    </span>
                  </div>
                  <div className="w-full bg-gray-800 rounded-full h-2">
                    <motion.div 
                      className={`h-full rounded-full ${
                        kellyPercentage > 25 ? 'bg-red-400' : 
                        kellyPercentage > 15 ? 'bg-yellow-400' : 
                        'bg-green-400'
                      }`}
                      initial={{ width: 0 }}
                      animate={{ width: `${Math.min(kellyPercentage * 4, 100)}%` }}
                      transition={{ duration: 0.5 }}
                    />
                  </div>
                </div>
              </div>
            </div>

            {/* Expected Value Display */}
            <div className="bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-2xl p-6">
              <h3 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
                <TrendingUp className="w-5 h-5 text-green-400" />
                Expected Outcomes
              </h3>
              
              <div className="space-y-4">
                <div className="flex justify-between items-center p-3 bg-black/30 rounded-lg">
                  <span className="text-sm text-gray-400">If Win ({givenOdds})</span>
                  <span className="text-green-400 font-mono">
                    +${(betSize * (americanToDecimal(givenOdds) - 1)).toFixed(0)}
                  </span>
                </div>
                <div className="flex justify-between items-center p-3 bg-black/30 rounded-lg">
                  <span className="text-sm text-gray-400">If Lose</span>
                  <span className="text-red-400 font-mono">
                    -${betSize}
                  </span>
                </div>
                <div className="border-t border-gray-700 pt-4">
                  <div className="flex justify-between items-center">
                    <span className="text-sm text-gray-400">Expected Value</span>
                    <span className={`font-mono font-bold ${
                      ((1 / americanToDecimal(trueOdds)) * (americanToDecimal(givenOdds) - 1) - (1 - (1 / americanToDecimal(trueOdds)))) > 0 
                        ? 'text-green-400' 
                        : 'text-red-400'
                    }`}>
                      ${(((1 / americanToDecimal(trueOdds)) * betSize * (americanToDecimal(givenOdds) - 1)) - ((1 - (1 / americanToDecimal(trueOdds))) * betSize)).toFixed(0)}
                    </span>
                  </div>
                </div>
              </div>
            </div>

            {/* Warning */}
            {kellyPercentage > 25 && (
              <motion.div 
                className="bg-red-500/10 border border-red-500/30 rounded-xl p-4"
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
              >
                <div className="flex items-start gap-3">
                  <AlertCircle className="w-5 h-5 text-red-400 mt-0.5" />
                  <div>
                    <p className="text-sm text-red-400 font-medium">High Risk Alert</p>
                    <p className="text-xs text-gray-400 mt-1">
                      Kelly suggests {kellyPercentage.toFixed(1)}% of bankroll. Consider using a fractional Kelly (25-50% of suggested) for safety.
                    </p>
                  </div>
                </div>
              </motion.div>
            )}
          </motion.div>
        </div>

        {/* Bottom CTA */}
        <motion.div 
          className="mt-16 text-center"
          initial={{ opacity: 0 }}
          animate={inView ? { opacity: 1 } : {}}
          transition={{ delay: 1 }}
        >
          <p className="text-gray-400 mb-6">
            Ready to apply professional position sizing to your strategy?
          </p>
          <motion.a
            href="https://apps.apple.com/app/kelly-stakes"
            className="inline-flex items-center gap-2 px-8 py-4 bg-gradient-to-r from-green-400 to-emerald-400 text-black font-bold rounded-xl"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <Zap className="w-5 h-5" />
            Get Kelly Stakes Free
          </motion.a>
        </motion.div>
      </div>

      <style jsx>{`
        input[type="range"]::-webkit-slider-thumb {
          appearance: none;
          width: 20px;
          height: 20px;
          background: rgb(74, 222, 128);
          cursor: pointer;
          border-radius: 50%;
          box-shadow: 0 0 10px rgba(74, 222, 128, 0.5);
        }
        input[type="range"]::-moz-range-thumb {
          width: 20px;
          height: 20px;
          background: rgb(74, 222, 128);
          cursor: pointer;
          border-radius: 50%;
          border: none;
          box-shadow: 0 0 10px rgba(74, 222, 128, 0.5);
        }
      `}</style>
    </section>
  );
};

export default LiveDemo;