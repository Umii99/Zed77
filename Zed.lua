<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Grow A Garden - ZedHub UI Premium</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * {
            user-select: none;
            -webkit-user-select: none;
            box-sizing: border-box;
        }
        
        body {
            margin: 0;
            padding: 0;
            width: 100vw;
            height: 100vh;
            background-color: #020617;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .custom-scrollbar::-webkit-scrollbar {
            width: 3px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
            background: rgba(15, 23, 42, 0.6);
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
            background: rgba(59, 130, 246, 0.4);
            border-radius: 2px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
            background: rgba(59, 130, 246, 0.8);
        }

        .accordion-content {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            max-height: 0;
            opacity: 0;
            overflow: hidden;
        }

        .accordion-content.expanded {
            max-height: 5000px;
            opacity: 1;
            margin-top: 0.5rem;
        }

        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
        }

        /* Skala UI agar selalu pas dan proporsional di Landscape HP */
        #hubUI {
            width: 680px;
            height: 400px;
            max-width: 96vw;
            max-height: 92vh;
            transform-origin: center;
        }

        /* Gaya List Vertikal Premium */
        .item-list-container {
            display: flex;
            flex-direction: column;
            gap: 3px;
            max-height: 110px;
            overflow-y: auto;
            padding: 3px;
            background: rgba(3, 7, 18, 0.85);
            border: 1px solid rgba(59, 130, 246, 0.25);
            border-radius: 6px;
            box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.6);
        }

        .item-row {
            background: rgba(15, 23, 42, 0.75);
            border: 1px solid rgba(51, 65, 85, 0.5);
            border-radius: 5px;
            padding: 5px 8px;
            font-size: 10.5px;
            color: #94a3b8;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .item-row:hover {
            border-color: rgba(59, 130, 246, 0.6);
            color: #cbd5e1;
            background: rgba(30, 41, 59, 0.7);
        }

        .item-row.selected {
            background: rgba(59, 130, 246, 0.2);
            border-color: #3b82f6;
            color: #ffffff;
            font-weight: 600;
            box-shadow: 0 0 6px rgba(59, 130, 246, 0.25);
        }

        .item-row input[type="checkbox"] {
            width: 13px;
            height: 13px;
            accent-color: #3b82f6;
            cursor: pointer;
        }
    </style>
</head>
<body class="font-sans antialiased">

    <!-- Floating Icon saat Minimize -->
    <button id="floatingBtn" onclick="restoreUI(event)" class="hidden fixed top-3 left-3 z-[9999] bg-slate-900/95 hover:bg-slate-800 text-blue-400 border border-blue-500/30 shadow-xl px-2.5 py-1.5 rounded-xl font-bold text-xs transition-all backdrop-blur-md flex items-center gap-1.5">
        <span>🪐</span>
        <span>ZedHub</span>
        <span class="text-[9px] bg-blue-500/10 text-blue-400 px-1 py-0.5 rounded border border-blue-500/20">Buka</span>
    </button>

    <!-- Modal Konfirmasi Keluar -->
    <div id="exitModal" class="hidden fixed inset-0 z-[10000] bg-black/70 backdrop-blur-sm flex items-center justify-center p-3">
        <div class="bg-slate-900 border border-slate-700/80 rounded-xl p-3.5 max-w-[260px] w-full shadow-2xl space-y-2.5 text-center">
            <div class="text-xs font-semibold text-slate-200">Are you sure wanna exit?</div>
            <div class="flex items-center gap-2 justify-center pt-1">
                <button onclick="confirmExit(true)" class="flex-1 bg-red-600/80 hover:bg-red-600 text-white font-semibold text-xs py-1.5 rounded transition-colors">Yes</button>
                <button onclick="confirmExit(false)" class="flex-1 bg-slate-800 hover:bg-slate-700 text-slate-300 font-semibold text-xs py-1.5 rounded transition-colors">No</button>
            </div>
        </div>
    </div>

    <!-- Main UI Container (Ukuran Pas & Proporsional di Landscape) -->
    <div id="hubUI" class="bg-slate-900/95 border border-slate-800/80 rounded-xl shadow-2xl shadow-black/80 overflow-hidden flex flex-col backdrop-blur-md relative z-10 transition-all duration-300">
        
        <!-- Top Title Bar -->
        <div class="h-9 bg-slate-950/80 border-b border-slate-800/80 px-3 flex items-center justify-between relative z-20 shrink-0">
            <div class="flex items-center gap-2">
                <div class="flex items-center gap-1 font-bold text-white text-xs">
                    <span>🪐</span>
                    <span class="bg-gradient-to-r from-blue-400 to-indigo-300 bg-clip-text text-transparent">ZedHub</span>
                </div>
                <span class="text-[9px] bg-slate-800/80 text-slate-400 px-1.5 py-0.5 rounded-full border border-slate-700/50">
                    Grow A Garden
                </span>
            </div>

            <div class="flex items-center gap-2">
                <span id="fpsCounter" class="text-[9px] font-semibold bg-blue-500/10 text-blue-400 px-1.5 py-0.5 rounded border border-blue-500/20">
                    -- FPS
                </span>
                
                <div class="flex items-center gap-1">
                    <button onclick="minimizeUI(event)" title="Minimize" class="w-5 h-5 rounded flex items-center justify-center text-slate-400 hover:text-white hover:bg-slate-800 transition-colors">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12H4"/></svg>
                    </button>
                    <button onclick="promptExit(event)" title="Tutup" class="w-5 h-5 rounded flex items-center justify-center text-slate-400 hover:text-red-400 hover:bg-red-500/10 transition-colors">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                    </button>
                </div>
            </div>
        </div>

        <!-- Body Layout -->
        <div class="flex flex-row flex-1 overflow-hidden">
            
            <!-- Left Sidebar Navigation -->
            <div class="w-32 bg-slate-950/40 border-r border-slate-800/80 p-2 flex flex-col justify-between items-stretch gap-1 relative z-10 shrink-0">
                <div class="flex flex-col gap-1 w-full">
                    <button id="navInfo" onclick="switchTab('info')" class="text-left px-2.5 py-1.5 rounded-md text-[11px] font-semibold bg-blue-600/15 text-blue-400 border-l-2 border-blue-500 transition-all flex items-center gap-1.5 whitespace-nowrap">
                        <svg class="w-3 h-3 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                        Info
                    </button>
                    <button id="navEvent" onclick="switchTab('event')" class="text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap">
                        <svg class="w-3 h-3 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                        Event
                    </button>
                    <button id="navAutoSelling" onclick="switchTab('autoselling')" class="text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap">
                        <svg class="w-3 h-3 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                        Auto Selling
                    </button>
                    <button id="navShop" onclick="switchTab('shop')" class="text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap">
                        <svg class="w-3 h-3 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                        Shop
                    </button>
                    <button id="navSettings" onclick="switchTab('settings')" class="text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap">
                        <svg class="w-3 h-3 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/></svg>
                        Settings
                    </button>
                </div>

                <div class="p-1.5 bg-slate-900/80 rounded-lg border border-slate-800/80 items-center gap-1.5 w-full flex shrink-0">
                    <div class="w-5 h-5 rounded bg-blue-500/20 border border-blue-500/30 flex items-center justify-center text-blue-400 font-bold text-[9px] shrink-0">Z</div>
                    <div class="overflow-hidden">
                        <div class="text-[10px] font-semibold text-slate-200 truncate">user_123</div>
                        <div class="text-[8px] text-slate-500 truncate">Premium</div>
                    </div>
                </div>
            </div>

            <!-- Middle Content Panel -->
            <div class="flex-1 p-3 custom-scrollbar overflow-y-auto">
                
                <!-- TAB 1: INFO -->
                <div id="tabInfo" class="tab-content active space-y-2.5">
                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('serverContent', 'serverChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-blue-400">
                                <span class="w-1 h-2.5 bg-blue-500 rounded-full"></span>
                                <span>SERVER</span>
                            </div>
                            <svg id="serverChevron" class="w-3 h-3 text-slate-400 transform transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>
                        <div id="serverContent" class="accordion-content">
                            <div class="space-y-2 pt-1">
                                <input type="text" id="serverIdInput" placeholder="ID Server Game..." class="w-full bg-slate-900 border border-slate-800 rounded px-2.5 py-1.5 text-[11px] text-slate-200 placeholder-slate-500 focus:outline-none focus:border-blue-500">
                                <button onclick="searchServer(event)" class="w-full bg-blue-600/20 border border-blue-500/40 text-blue-300 font-semibold text-[11px] py-1.5 rounded">Mencari Server</button>
                            </div>
                        </div>
                    </div>

                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('webhookContent', 'webhookChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-amber-400">
                                <span class="w-1 h-2.5 bg-amber-500 rounded-full"></span>
                                <span>WEBHOOK SYSTEM</span>
                            </div>
                            <svg id="webhookChevron" class="w-3 h-3 text-slate-400 transform transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>
                        <div id="webhookContent" class="accordion-content">
                            <div class="space-y-2 pt-1">
                                <input type="text" id="webhookUrlInput" placeholder="URL Webhook Discord..." class="w-full bg-slate-900 border border-slate-800 rounded px-2.5 py-1.5 text-[11px] text-slate-200 placeholder-slate-500 focus:outline-none focus:border-amber-500">
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 2: EVENT FALL -->
                <div id="tabEvent" class="tab-content space-y-2.5">
                    <div class="bg-slate-950/60 border border-orange-500/40 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('fallControllerContent', 'fallControllerChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-orange-400">
                                <span class="w-1 h-2.5 bg-orange-500 rounded-full"></span>
                                <span>🍁 MARKET FALL CONTROLLER</span>
                            </div>
                            <svg id="fallControllerChevron" class="w-3.5 h-3.5 text-orange-400 transform transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>

                        <div id="fallControllerContent" class="accordion-content">
                            <div class="pt-1.5 space-y-2.5">
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 flex items-center justify-between">
                                    <span class="text-[10.5px] font-semibold text-slate-200">🌾 Auto Collect Required</span>
                                    <input type="checkbox" id="toggleAutoCollect" class="w-3 h-3 accent-orange-500 rounded">
                                </div>

                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 flex items-center justify-between">
                                    <span class="text-[10.5px] font-semibold text-slate-200">🪴 Auto Submit Required Plant</span>
                                    <input type="checkbox" id="toggleAutoSubmit" class="w-3 h-3 accent-orange-500 rounded">
                                </div>

                                <!-- Market Fall Shop Gear -->
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div class="flex items-center justify-between">
                                        <span class="text-[10.5px] font-bold text-amber-400">🛠️ Market Fall - Gear</span>
                                        <div class="flex items-center gap-2">
                                            <label class="flex items-center gap-1 text-[9px] text-amber-300 cursor-pointer">Buy All <input type="checkbox" id="toggleFallBuyAllGear" class="w-2.5 h-2.5 accent-amber-500 rounded" onchange="toggleBuyAllList('FallGear')"></label>
                                            <label class="flex items-center gap-1 text-[9px] text-slate-400 cursor-pointer">Auto Buy <input type="checkbox" id="toggleFallBuyGear" class="w-2.5 h-2.5 accent-orange-500 rounded"></label>
                                        </div>
                                    </div>
                                    <div id="listFallGear" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'FallGear')"><span>Leaf Rake</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallGear')"><span>Scarecrow Stick</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallGear')"><span>Acorn Lolipop</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallGear')"><span>Golden Acorn</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallGear')"><span>Golden Basket</span><input type="checkbox"></div>
                                    </div>
                                </div>

                                <!-- Market Fall Shop Seed -->
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div class="flex items-center justify-between">
                                        <span class="text-[10.5px] font-bold text-amber-400">🌱 Market Fall - Seed & Egg</span>
                                        <div class="flex items-center gap-2">
                                            <label class="flex items-center gap-1 text-[9px] text-amber-300 cursor-pointer">Buy All <input type="checkbox" id="toggleFallBuyAllSeed" class="w-2.5 h-2.5 accent-amber-500 rounded" onchange="toggleBuyAllList('FallSeed')"></label>
                                            <label class="flex items-center gap-1 text-[9px] text-slate-400 cursor-pointer">Auto Buy <input type="checkbox" id="toggleFallBuySeed" class="w-2.5 h-2.5 accent-orange-500 rounded"></label>
                                        </div>
                                    </div>
                                    <div id="listFallSeed" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'FallSeed')"><span>Pumpkin Seed</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallSeed')"><span>Wheat Seed</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallSeed')"><span>Turnip</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallSeed')"><span>Golden Acorn Seed</span><input type="checkbox"></div>
                                    </div>
                                </div>

                                <!-- Market Fall Shop Pets -->
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div class="flex items-center justify-between">
                                        <span class="text-[10.5px] font-bold text-amber-400">🐾 Market Fall - Pets & Crate</span>
                                        <div class="flex items-center gap-2">
                                            <label class="flex items-center gap-1 text-[9px] text-amber-300 cursor-pointer">Buy All <input type="checkbox" id="toggleFallBuyAllPets" class="w-2.5 h-2.5 accent-amber-500 rounded" onchange="toggleBuyAllList('FallPets')"></label>
                                            <label class="flex items-center gap-1 text-[9px] text-slate-400 cursor-pointer">Auto Buy <input type="checkbox" id="toggleFallBuyPets" class="w-2.5 h-2.5 accent-orange-500 rounded"></label>
                                        </div>
                                    </div>
                                    <div id="listFallPets" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'FallPets')"><span>Squirrel</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallPets')"><span>Fall Owl</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallPets')"><span>Space Squirrel</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallPets')"><span>Red Panda</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallPets')"><span>Fall Egg</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallPets')"><span>Fall Fox</span><input type="checkbox"></div>
                                    </div>
                                </div>

                                <!-- Market Fall Shop Crate -->
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div class="flex items-center justify-between">
                                        <span class="text-[10.5px] font-bold text-amber-400">✨ Market Fall - Kosmetik</span>
                                        <div class="flex items-center gap-2">
                                            <label class="flex items-center gap-1 text-[9px] text-amber-300 cursor-pointer">Buy All <input type="checkbox" id="toggleFallBuyAllCrate" class="w-2.5 h-2.5 accent-amber-500 rounded" onchange="toggleBuyAllList('FallCrate')"></label>
                                            <label class="flex items-center gap-1 text-[9px] text-slate-400 cursor-pointer">Auto Buy <input type="checkbox" id="toggleFallBuyCrate" class="w-2.5 h-2.5 accent-orange-500 rounded"></label>
                                        </div>
                                    </div>
                                    <div id="listFallCrate" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Fall Crate</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Fall Mountain</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Fall Festival Crate</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Golden Fall Box</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Autumn Leaf Hat</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Harvest Crown</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'FallCrate')"><span>Maple Cape</span><input type="checkbox"></div>
                                    </div>
                                </div>

                                <!-- Shady Scarecrow -->
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1">
                                    <div class="flex items-center justify-between">
                                        <span class="text-[10.5px] font-semibold text-slate-200">🌾 Shady Scarecrow</span>
                                        <span class="text-[9px] text-amber-300 font-medium">Select Seed</span>
                                    </div>
                                    <div id="listScarecrow" class="item-list-container" style="max-height: 70px;">
                                        <div class="item-row selected" onclick="toggleScarecrowMode(this, 'GOLD_EGG_SEED')"><span>Gold Egg Seed (Benih Telur Emas)</span><input type="checkbox" checked></div>
                                        <div class="item-row" onclick="toggleScarecrowMode(this, 'ALL_SEED')"><span>All Seed (Semua Benih)</span><input type="checkbox"></div>
                                    </div>
                                </div>

                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 flex items-center justify-between">
                                    <span class="text-[10.5px] font-semibold text-slate-200">🌱 Give A Seed</span>
                                    <input type="checkbox" id="toggleGiveAside" class="w-3 h-3 accent-orange-500 rounded">
                                </div>

                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 flex items-center justify-between">
                                    <span class="text-[10.5px] font-semibold text-slate-200">🌰 Auto Shovel Acorn</span>
                                    <input type="checkbox" id="toggleAutoShovel" class="w-3 h-3 accent-orange-500 rounded">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 3: AUTO SELLING -->
                <div id="tabAutoSelling" class="tab-content space-y-2.5">
                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('autoSellingContent', 'autoSellingChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-blue-400">
                                <span class="w-1 h-2.5 bg-blue-500 rounded-full"></span>
                                <span>AUTO SELLING FRUIT</span>
                            </div>
                            <svg id="autoSellingChevron" class="w-3.5 h-3.5 text-slate-400 transform transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>

                        <div id="autoSellingContent" class="accordion-content">
                            <div class="pt-1.5 space-y-2">
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 flex items-center justify-between">
                                    <span class="text-[10.5px] font-semibold text-slate-200">Auto Sell If Backpack Full</span>
                                    <input type="checkbox" id="toggleAutoSellBackpack" class="w-3.5 h-3.5 accent-blue-500 rounded">
                                </div>
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 flex items-center justify-between">
                                    <span class="text-[10.5px] font-semibold text-slate-200">Auto Sell Fruit</span>
                                    <input type="checkbox" id="toggleAutoSellFruit" class="w-3.5 h-3.5 accent-blue-500 rounded">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- TAB 4: SHOP -->
                <div id="tabShop" class="tab-content space-y-2.5">
                    
                    <!-- 1. SHOP EGG -->
                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('shopEggContent', 'shopEggChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-purple-400">
                                <span class="w-1 h-2.5 bg-purple-500 rounded-full"></span>
                                <span>SHOP EGG</span>
                            </div>
                            <svg id="shopEggChevron" class="w-3.5 h-3.5 text-slate-400 transform transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>

                        <div id="shopEggContent" class="accordion-content">
                            <div class="pt-1.5 space-y-2">
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div id="listMainEgg" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'MainEgg')"><span>Common Egg</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainEgg')"><span>Uncommon Egg</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainEgg')"><span>Rare Egg</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainEgg')"><span>Mythichal Egg</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainEgg')"><span>Bugg Egg</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainEgg')"><span>Junggle Egg</span><input type="checkbox"></div>
                                    </div>
                                    
                                    <div class="flex items-center justify-between bg-slate-950/50 p-1.5 rounded border border-slate-800/80">
                                        <span class="text-[10.5px] font-semibold text-purple-300">Auto Buy (Selected)</span>
                                        <input type="checkbox" id="toggleAutoBuyShopEgg" class="w-3.5 h-3.5 accent-purple-500 rounded cursor-pointer">
                                    </div>

                                    <div class="flex items-center justify-between bg-slate-950/50 p-1.5 rounded border border-slate-800/80">
                                        <span class="text-[10.5px] font-semibold text-purple-300">Auto Buy All</span>
                                        <input type="checkbox" id="toggleAutoBuyAllShopEgg" class="w-3.5 h-3.5 accent-purple-500 rounded cursor-pointer" onchange="toggleBuyAllList('MainEgg')">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 2. SHOP SEED -->
                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('shopSeedContent', 'shopSeedChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-emerald-400">
                                <span class="w-1 h-2.5 bg-emerald-500 rounded-full"></span>
                                <span>SHOP SEED</span>
                            </div>
                            <svg id="shopSeedChevron" class="w-3.5 h-3.5 text-slate-400 transform transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>

                        <div id="shopSeedContent" class="accordion-content">
                            <div class="pt-1.5 space-y-2">
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div id="listMainSeed" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Carrot</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Strawberry</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Blueberry</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Tomato</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Buttercup</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Daffodil</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Corn</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Tulip</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Bamboo</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Watermelon</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Pumpkin</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Coconut</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Manggo</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Pineapple</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Apple</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Grape</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Dragon Fruit</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Cactus</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Papper</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Mushroom</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Cacao Bean</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Beanstalk</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Ember Lily</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Suggar Apple</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Burning Bud</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Giant Pinecone</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Elder Strawberry</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Romanesco</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Crimson Thorn</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Zebra</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Zinkle</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Octobloom</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Alien Apple</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainSeed')"><span>Aurum Spire</span><input type="checkbox"></div>
                                    </div>

                                    <div class="flex items-center justify-between bg-slate-950/50 p-1.5 rounded border border-slate-800/80">
                                        <span class="text-[10.5px] font-semibold text-emerald-300">Auto Buy (Selected)</span>
                                        <input type="checkbox" id="toggleAutoBuyShopSeed" class="w-3.5 h-3.5 accent-emerald-500 rounded cursor-pointer">
                                    </div>

                                    <div class="flex items-center justify-between bg-slate-950/50 p-1.5 rounded border border-slate-800/80">
                                        <span class="text-[10.5px] font-semibold text-emerald-300">Auto Buy All</span>
                                        <input type="checkbox" id="toggleAutoBuyAllShopSeed" class="w-3.5 h-3.5 accent-emerald-500 rounded cursor-pointer" onchange="toggleBuyAllList('MainSeed')">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 3. SHOP GEAR -->
                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5 space-y-2">
                        <button onclick="toggleAccordion('shopGearContent', 'shopGearChevron', event)" class="w-full flex items-center justify-between text-left group">
                            <div class="flex items-center gap-2 text-[11px] font-bold text-sky-400">
                                <span class="w-1 h-2.5 bg-sky-500 rounded-full"></span>
                                <span>SHOP GEAR</span>
                            </div>
                            <svg id="shopGearChevron" class="w-3.5 h-3.5 text-slate-400 transform transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>

                        <div id="shopGearContent" class="accordion-content">
                            <div class="pt-1.5 space-y-2">
                                <div class="bg-slate-900/70 p-2 rounded-md border border-slate-800 space-y-1.5">
                                    <div id="listMainGear" class="item-list-container">
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Advanced Sprinkler</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Grandmaster</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Godly Sprinkler</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Master Sprinkler</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Basic Sprinkler</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Harvest Tools</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Favorite Tools</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Recall Wrench</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Cleaning Spray</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Cleansing Shard</span><input type="checkbox"></div>
                                        <div class="item-row" onclick="toggleRow(this, 'MainGear')"><span>Level Up Lollipop</span><input type="checkbox"></div>
                                    </div>

                                    <div class="flex items-center justify-between bg-slate-950/50 p-1.5 rounded border border-slate-800/80">
                                        <span class="text-[10.5px] font-semibold text-sky-300">Auto Buy (Selected)</span>
                                        <input type="checkbox" id="toggleAutoBuyShopGear" class="w-3.5 h-3.5 accent-sky-500 rounded cursor-pointer">
                                    </div>

                                    <div class="flex items-center justify-between bg-slate-950/50 p-1.5 rounded border border-slate-800/80">
                                        <span class="text-[10.5px] font-semibold text-sky-300">Auto Buy All</span>
                                        <input type="checkbox" id="toggleAutoBuyAllShopGear" class="w-3.5 h-3.5 accent-sky-500 rounded cursor-pointer" onchange="toggleBuyAllList('MainGear')">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- TAB 5: SETTINGS -->
                <div id="tabSettings" class="tab-content space-y-2.5">
                    <div class="bg-slate-950/60 border border-slate-800/80 rounded-lg p-2.5">
                        <div class="text-[11px] font-bold text-slate-300 mb-1">General Settings</div>
                        <p class="text-[10px] text-slate-500">Konfigurasi umum aplikasi.</p>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <!-- ======================================================== -->
    <!-- ZEDHUB LUA SCRIPT EMBED                                  -->
    <!-- ======================================================== -->
    <script type="text/lua" id="zedhubScriptCore">
        getgenv().ZedHubConfig = {
            AutoCollect = false,
            AutoSubmitFallBloom = false,
            GiveASeed = false,
            AutoShovel = false,
            ShadyScarecrowMode = "GOLD_EGG_SEED",
            AutoSellBackpack = false,
            AutoSellFruit = false,
            
            FallMarketBuy = {
                FallGear = { Active = false, BuyAll = false, Items = {} },
                FallSeed = { Active = false, BuyAll = false, Items = {} },
                FallPets = { Active = false, BuyAll = false, Items = {} },
                FallCrate = { Active = false, BuyAll = false, Items = {} }
            },
            
            MainShopBuy = {
                MainEgg = { Active = false, BuyAll = false, Items = {} },
                MainSeed = { Active = false, BuyAll = false, Items = {} },
                MainGear = { Active = false, BuyAll = false, Items = {} }
            }
        }

        local Workspace = game:GetService("Workspace")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TweenService = game:GetService("TweenService")
        local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
        local GameEvents = ReplicatedStorage:FindFirstChild("GameEvents")

        local isProcessingScarecrow = false
        local IsSelling = false

        -- Presisi Auto Sell (Koordinat Kasir)
        local function PreciseSellInventory()
            if IsSelling then return end
            IsSelling = true
            pcall(function()
                local character = LocalPlayer.Character
                if not character then IsSelling = false return end
                local hrp = character:FindFirstChild("HumanoidRootPart")
                local sheckles = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Sheckles")
                if not hrp or not sheckles then IsSelling = false return end

                local previousCFrame = hrp.CFrame
                local previousSheckles = sheckles.Value

                hrp.CFrame = CFrame.new(62, 4, -26)
                task.wait(0.3)

                while task.wait(0.2) do
                    if sheckles.Value ~= previousSheckles then break end
                    if GameEvents and GameEvents:FindFirstChild("Sell_Inventory") then
                        GameEvents.Sell_Inventory:FireServer()
                    end
                end
                task.wait(0.2)
                hrp.CFrame = previousCFrame
            end)
            IsSelling = false
        end

        task.spawn(function()
            while task.wait(3) do
                local backpackOn = getgenv().ZedHubConfig.AutoSellBackpack
                local fruitOn = getgenv().ZedHubConfig.AutoSellFruit
                local count = 0
                pcall(function()
                    for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if t:FindFirstChild("Item_String") then count += 1 end
                    end
                end)

                if (backpackOn and count >= 15) or (backpackOn and not fruitOn and count >= 15) or (not backpackOn and fruitOn) then
                    PreciseSellInventory()
                    task.wait(4)
                end
            end
        end)

        local function GetEventRequiredItemName()
            if not PlayerGui then return nil end
            for _, gui in pairs(PlayerGui:GetChildren()) do
                if gui.Name:lower():find("event") or gui.Name:lower():find("fall") or gui.Name:lower():find("bloom") then
                    for _, desc in pairs(gui:GetDescendants()) do
                        if desc:IsA("TextLabel") and (desc.Text:lower():find("need") or desc.Text:lower():find("require") or desc.Text:lower():find("/")) then
                            return desc.Text
                        end
                    end
                end
            end
            return nil
        end

        -- Smart Auto Collect Required
        task.spawn(function()
            while task.wait(2) do
                if getgenv().ZedHubConfig.AutoCollect then
                    pcall(function()
                        local requiredKeyword = GetEventRequiredItemName()
                        local foundTarget = false
                        local myFarm = Workspace:FindFirstChild("Farm")

                        if myFarm then
                            for _, plant in pairs(myFarm:GetDescendants()) do
                                if plant:IsA("Model") or plant:IsA("Part") then
                                    local pName = plant.Name:lower()
                                    local match = false

                                    if requiredKeyword and pName:find(requiredKeyword:lower()) then
                                        match = true
                                    elseif not requiredKeyword and (pName:find("fall") or pName:find("bloom") or pName:find("event")) then
                                        match = true
                                    end

                                    if match then
                                        local prompt = plant:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if prompt and prompt.Enabled then
                                            foundTarget = true
                                            fireproximityprompt(prompt)
                                            task.wait(0.2)
                                        end
                                    end
                                end
                            end
                        end

                        if not foundTarget then
                            task.wait(4)
                        end
                    end)
                end
            end
        end)

        -- Auto Submit Required Plant
        task.spawn(function()
            while task.wait(3) do
                if getgenv().ZedHubConfig.AutoSubmitFallBloom then
                    pcall(function()
                        local needed = GetEventRequiredItemName()
                        local backpack = LocalPlayer.Backpack
                        for _, tool in pairs(backpack:GetChildren()) do
                            if tool:IsA("Tool") and (not needed or tool.Name:lower():find(needed:lower()) or tool.Name:lower():find("fall")) then
                                local submitEvt = GameEvents and (GameEvents:FindFirstChild("SubmitFallPlant") or GameEvents:FindFirstChild("SubmitEvent"))
                                if submitEvt then
                                    submitEvt:FireServer(tool)
                                    task.wait(0.5)
                                end
                            end
                        end
                    end)
                end
            end
        end)

        -- List Checkbox Auto Buy Engine
        task.spawn(function()
            while task.wait(2) do
                pcall(function()
                    local buyEvt = GameEvents and (GameEvents:FindFirstChild("BuyEventShop") or GameEvents:FindFirstChild("BuyMarketItem") or GameEvents:FindFirstChild("BuySeedStock"))
                    if not buyEvt then return end

                    for cat, data in pairs(getgenv().ZedHubConfig.FallMarketBuy) do
                        if data.Active or data.BuyAll then
                            if data.BuyAll then
                                buyEvt:FireServer(cat, "BUY_ALL")
                            else
                                for _, itemName in pairs(data.Items) do
                                    buyEvt:FireServer(cat, itemName)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end

                    for cat, data in pairs(getgenv().ZedHubConfig.MainShopBuy) do
                        if data.Active or data.BuyAll then
                            if data.BuyAll then
                                buyEvt:FireServer(cat, "BUY_ALL")
                            else
                                for _, itemName in pairs(data.Items) do
                                    buyEvt:FireServer(cat, itemName)
                                    task.wait(0.2)
                                end
                            end
                        end
                    end
                end)
            end
        end)

        -- Shady Scarecrow
        local function EquipSpecificSeed(mode)
            local character = LocalPlayer.Character
            local backpack = LocalPlayer.Backpack
            if not character then return false end
            local keywords = (mode == "GOLD_EGG_SEED") and {"gold", "egg", "golden"} or {"seed"}

            local currentTool = character:FindFirstChildOfClass("Tool")
            if currentTool then
                local tName = currentTool.Name:lower()
                for _, kw in pairs(keywords) do if tName:find(kw) then return true end end
            end

            for _, item in pairs(backpack:GetChildren()) do
                if item:IsA("Tool") then
                    local iName = item.Name:lower()
                    for _, kw in pairs(keywords) do
                        if iName:find(kw) then
                            if currentTool then currentTool.Parent = backpack end
                            item.Parent = character
                            task.wait(0.4)
                            return true
                        end
                    end
                end
            end
            return false
        end

        task.spawn(function()
            while task.wait(5) do
                if getgenv().ZedHubConfig.GiveASeed and not isProcessingScarecrow then
                    pcall(function()
                        isProcessingScarecrow = true
                        local mode = getgenv().ZedHubConfig.ShadyScarecrowMode
                        if EquipSpecificSeed(mode) then
                            local scarecrow = nil
                            for _, obj in pairs(Workspace:GetChildren()) do
                                if obj.Name:lower():find("scarecrow") or obj.Name:lower():find("shady") then
                                    scarecrow = obj
                                    break
                                end
                            end

                            if scarecrow then
                                local npcPart = scarecrow:FindFirstChild("HumanoidRootPart") or scarecrow.PrimaryPart or scarecrow:FindFirstChildWhichIsA("BasePart")
                                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                                if npcPart and hrp then
                                    local origin = hrp.CFrame
                                    local dist = (hrp.Position - npcPart.Position).Magnitude
                                    local tween = TweenService:Create(hrp, TweenInfo.new(dist / 25, Enum.EasingStyle.Linear), {CFrame = npcPart.CFrame + Vector3.new(0, 3, 0)})
                                    tween:Play()
                                    tween.Completed:Wait()
                                    task.wait(0.4)

                                    local giveEvt = GameEvents and GameEvents:FindFirstChild("ScarecrowGiveSeed")
                                    if giveEvt then giveEvt:FireServer(mode)
                                    else
                                        local p = scarecrow:FindFirstChildWhichIsA("ProximityPrompt", true)
                                        if p then fireproximityprompt(p) end
                                    end
                                    task.wait(0.8)

                                    local rTween = TweenService:Create(hrp, TweenInfo.new((hrp.Position - origin.Position).Magnitude / 25, Enum.EasingStyle.Linear), {CFrame = origin})
                                    rTween:Play()
                                    rTween.Completed:Wait()
                                end
                            end
                        end
                        isProcessingScarecrow = false
                    end)
                end
            end
        end)

        print("ZedHub Master Engine Loaded!")
    </script>

    <script>
        let lastFrameTime = performance.now();
        let frameCount = 0;
        function updateFPS() {
            const now = performance.now();
            frameCount++;
            if (now - lastFrameTime >= 1000) {
                const fps = Math.round((frameCount * 1000) / (now - lastFrameTime));
                const fpsEl = document.getElementById('fpsCounter');
                if (fpsEl) fpsEl.textContent = fps + " FPS";
                frameCount = 0;
                lastFrameTime = now;
            }
            requestAnimationFrame(updateFPS);
        }
        requestAnimationFrame(updateFPS);

        function adjustUIScale() {
            const ui = document.getElementById('hubUI');
            const targetW = 680;
            const targetH = 400;
            const scaleX = window.innerWidth / targetW;
            const scaleY = window.innerHeight / targetH;
            let scale = Math.min(scaleX, scaleY, 1);
            if (window.innerWidth < 700 || window.innerHeight < 450) {
                ui.style.transform = `scale(${scale * 0.95})`;
            } else {
                ui.style.transform = 'scale(1)';
            }
        }
        window.addEventListener('resize', adjustUIScale);
        window.addEventListener('orientationchange', adjustUIScale);
        adjustUIScale();

        function switchTab(tabName) {
            document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
            const btnInfo = document.getElementById('navInfo');
            const btnEvent = document.getElementById('navEvent');
            const btnAutoSelling = document.getElementById('navAutoSelling');
            const btnShop = document.getElementById('navShop');
            const btnSettings = document.getElementById('navSettings');

            btnInfo.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap";
            btnEvent.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap";
            btnAutoSelling.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap";
            btnShop.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap";
            btnSettings.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-medium text-slate-400 hover:text-slate-200 hover:bg-slate-800/40 transition-all flex items-center gap-1.5 whitespace-nowrap";

            if (tabName === 'info') {
                document.getElementById('tabInfo').classList.add('active');
                btnInfo.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-semibold bg-blue-600/15 text-blue-400 border-l-2 border-blue-500 transition-all flex items-center gap-1.5 whitespace-nowrap";
            } else if (tabName === 'event') {
                document.getElementById('tabEvent').classList.add('active');
                btnEvent.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-semibold bg-orange-600/15 text-orange-400 border-l-2 border-orange-500 transition-all flex items-center gap-1.5 whitespace-nowrap";
            } else if (tabName === 'autoselling') {
                document.getElementById('tabAutoSelling').classList.add('active');
                btnAutoSelling.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-semibold bg-blue-600/15 text-blue-400 border-l-2 border-blue-500 transition-all flex items-center gap-1.5 whitespace-nowrap";
            } else if (tabName === 'shop') {
                document.getElementById('tabShop').classList.add('active');
                btnShop.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-semibold bg-purple-600/15 text-purple-400 border-l-2 border-purple-500 transition-all flex items-center gap-1.5 whitespace-nowrap";
            } else if (tabName === 'settings') {
                document.getElementById('tabSettings').classList.add('active');
                btnSettings.className = "text-left px-2.5 py-1.5 rounded-md text-[11px] font-semibold bg-blue-600/15 text-blue-400 border-l-2 border-blue-500 transition-all flex items-center gap-1.5 whitespace-nowrap";
            }
        }

        function toggleAccordion(contentId, chevronId, event) {
            if (event) event.stopPropagation();
            document.getElementById(contentId).classList.toggle('expanded');
            document.getElementById(chevronId).classList.toggle('rotate-180');
        }

        function minimizeUI(event) {
            if (event) event.stopPropagation();
            document.getElementById('hubUI').classList.add('hidden');
            document.getElementById('floatingBtn').classList.remove('hidden');
        }

        function restoreUI(event) {
            if (event) event.stopPropagation();
            document.getElementById('hubUI').classList.remove('hidden');
            document.getElementById('floatingBtn').classList.add('hidden');
        }

        function promptExit(event) {
            if (event) event.stopPropagation();
            document.getElementById('exitModal').classList.remove('hidden');
        }

        function confirmExit(choice) {
            if (choice) {
                document.getElementById('hubUI').classList.add('hidden');
                document.getElementById('exitModal').classList.add('hidden');
                document.getElementById('floatingBtn').classList.remove('hidden');
            } else {
                document.getElementById('exitModal').classList.add('hidden');
            }
        }

        function toggleRow(rowElement, categoryKey) {
            const checkbox = rowElement.querySelector('input[type="checkbox"]');
            checkbox.checked = !checkbox.checked;
            rowElement.classList.toggle('selected', checkbox.checked);

            const container = rowElement.parentElement;
            const selectedRows = container.querySelectorAll('.item-row.selected');
            const itemsArray = Array.from(selectedRows).map(row => row.querySelector('span').innerText.trim());

            if (categoryKey.startsWith('Fall')) {
                if (window.ZedHubConfig && ZedHubConfig.FallMarketBuy[categoryKey]) {
                    ZedHubConfig.FallMarketBuy[categoryKey].Items = itemsArray;
                    ZedHubConfig.FallMarketBuy[categoryKey].Active = itemsArray.length > 0;
                }
            } else {
                if (window.ZedHubConfig && ZedHubConfig.MainShopBuy[categoryKey]) {
                    ZedHubConfig.MainShopBuy[categoryKey].Items = itemsArray;
                    ZedHubConfig.MainShopBuy[categoryKey].Active = itemsArray.length > 0;
                }
            }
        }

        function toggleScarecrowMode(rowElement, modeValue) {
            const container = rowElement.parentElement;
            container.querySelectorAll('.item-row').forEach(r => {
                r.classList.remove('selected');
                r.querySelector('input').checked = false;
            });
            rowElement.classList.add('selected');
            rowElement.querySelector('input').checked = true;

            if (window.ZedHubConfig) {
                ZedHubConfig.ShadyScarecrowMode = modeValue;
            }
        }

        function toggleBuyAllList(categoryKey) {
            const isBuyAllChecked = document.getElementById(categoryKey.startsWith('Fall') ? `toggleFallBuyAll${categoryKey.replace('Fall','')}` : `toggleAutoBuyAllShop${categoryKey.replace('Main','')}`).checked;
            
            if (categoryKey.startsWith('Fall')) {
                if (ZedHubConfig && ZedHubConfig.FallMarketBuy[categoryKey]) {
                    ZedHubConfig.FallMarketBuy[categoryKey].BuyAll = isBuyAllChecked;
                }
            } else {
                if (ZedHubConfig && ZedHubConfig.MainShopBuy[categoryKey]) {
                    ZedHubConfig.MainShopBuy[categoryKey].BuyAll = isBuyAllChecked;
                }
            }
        }
    </script>
</body>
</html>
