// ptbr_hints.gsc - Traducao PT-BR v22 para BO2 Zombies (Plutonium T6)
// v22: remove todos os logs de debug (println/iPrintLn) para producao
//      fix: tight_loop e re-apply nao sobrescrevem hint quando jogador
//      ja tem a arma, permitindo que cg_cursorHints mostre 'Recarregar arma'
// Chaves mapeadas via engenharia reversa dos zone files + PTBR.lua (251 ZOMBIE_*)

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

main()
{
    level thread ptbr_loop();
    level thread ptbr_wallbuy_tight_loop();
    level thread ptbr_late_weapon_probe();
}

init() { }

// =====================================================
// PROBE TARDIO: busca armas em gumps carregados apos init
// Roda 3x: t=20s, t=40s, t=70s para cobrir TranZit streaming
// =====================================================
ptbr_late_weapon_probe()
{
    _waits = [];
    _waits[0] = 20;
    _waits[1] = 20;
    _waits[2] = 30;
    for ( pass = 0; pass < 3; pass++ )
    {
        wait _waits[pass];
        ptbr_probe_run( pass );
    }
}

ptbr_probe_run( pass )
{
    _cn = [];
    _cn[0] = "trigger_use"; _cn[1] = "trigger_use_touch";
    _cn[2] = "trigger_multiple"; _cn[3] = "trigger_radius";

    for ( ci = 0; ci < 4; ci++ )
    {
        a = getentarray( _cn[ci], "classname" );
        for ( i = 0; i < a.size; i++ )
        {
            e = a[i];
            // Busca por zombie_weapon_upgrade nao traduzido
            if ( isDefined( e.zombie_weapon_upgrade ) )
            {
                if ( !isDefined( e._ptbr_text ) || e._ptbr_text == "" )
                {
                    wpn = "" + e.zombie_weapon_upgrade;
                    r = "Pressione ^3[{+activate}]^7 para " + ptbr_wn( wpn ) + " [Custo: " + ptbr_wc( wpn ) + "]";
                    e._ptbr_text = r;
                    e SetHintString( r );
                    ptbr_wallbuy_register( e );
                }
            }
            // Busca hints em ingles nao traduzidos
            if ( isDefined( e._ptbr_text ) && e._ptbr_text != "" ) continue;
            h = ""; if ( isDefined( e.hintstring ) ) h = "" + e.hintstring;
            if ( h == "" ) continue;
            hl = toLower( h );
            if ( isSubStr( hl, "pressione" ) || isSubStr( hl, "custo:" ) || isSubStr( hl, "peca" ) ) continue;
            if ( isSubStr( hl, "hold" ) || isSubStr( hl, "cost" ) || isSubStr( hl, " for " ) )
            {
                rr = ptbr_translate_raw_hint( h, e );
                if ( isDefined( rr ) )
                {
                    e._ptbr_text = rr;
                    e SetHintString( rr );
                    ptbr_wallbuy_register( e );
                }
            }
        }
    }
}

ptbr_loop()
{
    // v23: reseta _ptbr_text de todos os triggers para forcar re-deteccao com logica nova
    foreach ( _rt in getentarray( "trigger_use",       "classname" ) ) _rt._ptbr_text = undefined;
    foreach ( _rt in getentarray( "trigger_use_touch", "classname" ) ) _rt._ptbr_text = undefined;
    foreach ( _rt in getentarray( "trigger_multiple",  "classname" ) ) _rt._ptbr_text = undefined;
    foreach ( _rt in getentarray( "trigger_radius",    "classname" ) ) _rt._ptbr_text = undefined;
    wait 5;
    // reseta novamente apos wait 5 (entidades dinamicas criadas no init)
    foreach ( _rt in getentarray( "trigger_use",       "classname" ) ) _rt._ptbr_text = undefined;
    foreach ( _rt in getentarray( "trigger_use_touch", "classname" ) ) _rt._ptbr_text = undefined;
    foreach ( _rt in getentarray( "trigger_multiple",  "classname" ) ) _rt._ptbr_text = undefined;
    foreach ( _rt in getentarray( "trigger_radius",    "classname" ) ) _rt._ptbr_text = undefined;
    SetDvar( "cg_cursorHints", "4" );
    level thread ptbr_buildables_loop();
    level thread ptbr_barrier_scan_loop();
    level thread ptbr_unitrigger_loop();
    pass = 0;
    while ( true )
    {
        n = ptbr_scan();
        pass++;
        wait 0.1;
    }
}

// loop apertado 0.05s para armas/itens que o jogo sobreescreve continuamente
ptbr_wallbuy_tight_loop()
{
    level._ptbr_wbe = [];
    wait 6;
    while ( true )
    {
        for ( _wi = 0; _wi < level._ptbr_wbe.size; _wi++ )
        {
            _we = level._ptbr_wbe[_wi];
            if ( !isDefined( _we ) || !isDefined( _we._ptbr_text ) ) continue;
            // Nao sobrescrever hint quando jogador ja tem a arma:
            // engine (cg_cursorHints 4 + ptbr_mod.str) mostra "Recarregar arma" corretamente
            if ( isDefined( _we.zombie_weapon_upgrade ) && ptbr_player_has_weapon( "" + _we.zombie_weapon_upgrade ) ) continue;
            _we SetHintString( _we._ptbr_text );
        }
        wait 0.05;
    }
}

ptbr_wallbuy_register( ent )
{
    if ( !isDefined( ent ) || !isDefined( level._ptbr_wbe ) ) return;
    if ( isDefined( ent._ptbr_wbe_reg ) ) return;
    ent._ptbr_wbe_reg = true;
    level._ptbr_wbe[level._ptbr_wbe.size] = ent;
}

// =====================================================
// BUILDABLES - mesas de construcao
// =====================================================
ptbr_buildables_loop()
{
    wait 3;
    while ( true )
    {
        if ( isDefined( level.buildable_stubs ) )
        {
            keys = getArrayKeys( level.buildable_stubs );
            for ( i = 0; i < keys.size; i++ )
            {
                stub = level.buildable_stubs[keys[i]];
                if ( isDefined( stub ) ) ptbr_fix_stub( stub );
            }
        }
        wait 0.2;
    }
}

ptbr_fix_stub( stub )
{
    t = undefined;
    if ( !isDefined( t ) && isDefined( stub.trigger ) )      t = stub.trigger;
    if ( !isDefined( t ) && isDefined( stub.trig ) )         t = stub.trig;
    if ( !isDefined( t ) && isDefined( stub.e_trigger ) )    t = stub.e_trigger;
    if ( !isDefined( t ) && isDefined( stub.trigger_ent ) )  t = stub.trigger_ent;
    if ( !isDefined( t ) && isDefined( stub.trigger_touch ) ) t = stub.trigger_touch;

    r = "Pecas adicionais necessarias";
    if ( isDefined( stub.b_built ) && stub.b_built )
        r = "Pressione ^3[{+activate}]^7 para Construir";

    old_hs = ""; if ( isDefined( stub.hint_string ) ) old_hs = "" + stub.hint_string;
    stub.hint_string = r;
    if ( isDefined( t ) )
    {
        t._ptbr_text = r;
        t SetHintString( r );
    }
}

// =====================================================
// BARREIRAS - scan por stubs em triggers
// =====================================================
ptbr_barrier_scan_loop()
{
    wait 3;
    while ( true )
    {
        ptbr_barrier_class( "trigger_use" );
        ptbr_barrier_class( "trigger_use_touch" );
        ptbr_barrier_class( "trigger_radius" );
        ptbr_barrier_class( "trigger_multiple" );
        wait 0.2;
    }
}

ptbr_barrier_class( cn )
{
    a = getentarray( cn, "classname" );
    for ( i = 0; i < a.size; i++ )
    {
        e = a[i];
        if ( isDefined( e.unitrigger_stub ) ) ptbr_fix_barrier_stub( e, e.unitrigger_stub );
        if ( isDefined( e.stub ) )            ptbr_fix_barrier_stub( e, e.stub );
    }
}

ptbr_fix_barrier_stub( e, s )
{
    hl = "";
    if ( isDefined( s.hint_string ) ) hl = toLower( "" + s.hint_string );

    // Ja em portugues?
    if ( isSubStr( hl, "pressione" ) || isSubStr( hl, "pecas" ) ||
         isSubStr( hl, "peca" ) || isSubStr( hl, "barricada" ) ||
         isSubStr( hl, "construir" ) || isSubStr( hl, "incorreta" ) ||
         isSubStr( hl, "adicionais" ) || isSubStr( hl, "custo:" ) ) return;

    r = undefined;
    if      ( isSubStr( hl, "incorrect" ) || isSubStr( hl, "wrong part" ) )
        r = "Peca incorreta";
    else if ( isSubStr( hl, "rebuild" ) || isSubStr( hl, "barrier" ) )
        r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";
    else if ( isSubStr( hl, "additional" ) || isSubStr( hl, "parts required" ) )
        r = "Pecas adicionais necessarias";
    else if ( isSubStr( hl, "to build" ) || isSubStr( hl, "to craft" ) || isSubStr( hl, "bench" ) )
        r = "Pressione ^3[{+activate}]^7 para Construir";
    else if ( isSubStr( hl, "for part" ) || isSubStr( hl, "pick up" ) )
        r = "Pressione ^3[{+activate}]^7 para Peca";
    else if ( isSubStr( hl, "place part" ) || isSubStr( hl, "add part" ) )
        r = "Pressione ^3[{+activate}]^7 para colocar Peca";

    // Fallback: se o stub/trigger tem contexto de barreira e hint vazio, traduz
    if ( !isDefined( r ) && hl == "" )
    {
        etn = ""; if ( isDefined( e.targetname ) ) etn = toLower( "" + e.targetname );
        esn = ""; if ( isDefined( e.script_noteworthy ) ) esn = toLower( "" + e.script_noteworthy );
        stn = ""; if ( isDefined( s.targetname ) ) stn = toLower( "" + s.targetname );
        ssn = ""; if ( isDefined( s.script_noteworthy ) ) ssn = toLower( "" + s.script_noteworthy );
        ctx = etn + " " + esn + " " + stn + " " + ssn;
        if ( isSubStr( ctx, "board" ) || isSubStr( ctx, "barrier" ) || isSubStr( ctx, "window" ) ||
             isSubStr( ctx, "rebuild" ) || isSubStr( ctx, "zcb" ) || isSubStr( ctx, "blocker" ) )
            r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";
    }

    if ( isDefined( r ) )
    {
        s.hint_string = r;
        e._ptbr_text = r;
        e SetHintString( r );
    }
}

// =====================================================
// UNITRIGGER STUBS - sistema de perks/pecas/barreiras
// =====================================================
ptbr_unitrigger_loop()
{
    wait 4;
    while ( true )
    {
        ptbr_scan_ut_registry( level.registered_unitriggers );
        ptbr_scan_ut_registry( level.unitrigger_list );
        ptbr_scan_ut_registry( level.active_unitriggers );
        ptbr_scan_ut_registry( level.zm_unitriggers );
        ptbr_scan_ut_registry( level.unitriggers );
        ptbr_scan_ut_registry( level.a_unitrigger_stubs );
        wait 0.1;
    }
}

ptbr_scan_ut_registry( arr )
{
    if ( !isDefined( arr ) ) return;
    keys = getArrayKeys( arr );
    for ( i = 0; i < keys.size; i++ )
    {
        stub = arr[keys[i]];
        if ( isDefined( stub ) ) ptbr_fix_ut_stub( stub );
    }
}

ptbr_fix_ut_stub( stub )
{
    hs  = ""; if ( isDefined( stub.hint_string ) ) hs = "" + stub.hint_string;
    eh = stub; if ( isDefined( stub.trigger ) ) eh = stub.trigger;

    // Prioridade maxima: traduz hint raw antes de re-apply antigo
    rr = ptbr_translate_raw_hint( hs, eh );
    if ( isDefined( rr ) )
    {
        stub._ptbr_text = rr;
        stub.hint_string = rr;
        if ( isDefined( stub.trigger ) )
        {
            stub.trigger._ptbr_text = rr;
            stub.trigger SetHintString( rr );
        }
        return;
    }

    // Re-apply continuo
    if ( isDefined( stub._ptbr_text ) )
    {
        if ( stub._ptbr_text == "" )
            stub._ptbr_text = undefined;
        else
        {
            if ( isDefined( stub.zombie_weapon_upgrade ) && ptbr_player_has_weapon( "" + stub.zombie_weapon_upgrade ) ) return;
            stub.hint_string = stub._ptbr_text;
            if ( isDefined( stub.trigger ) ) stub.trigger SetHintString( stub._ptbr_text );
            return;
        }
    }

    hsl = toLower( hs );
    tn  = ""; if ( isDefined( stub.targetname ) ) tn = toLower( "" + stub.targetname );
    sn  = ""; if ( isDefined( stub.script_noteworthy ) ) sn = toLower( "" + stub.script_noteworthy );
    ss  = ""; if ( isDefined( stub.script_string ) ) ss = toLower( "" + stub.script_string );

    // Ja em portugues?
    if ( isSubStr( hsl, "pressione" ) || isSubStr( hsl, "pecas" ) || isSubStr( hsl, "peca" ) ||
         isSubStr( hsl, "construir" ) || isSubStr( hsl, "barricada" ) || isSubStr( hsl, "custo:" ) ||
         isSubStr( hsl, "necessar" ) || isSubStr( hsl, "energia" ) || isSubStr( hsl, "incorreta" ) )
        return;

    r = undefined;

    // PERKS - zombie_vending_* targetname
    if ( !isDefined( r ) && isSubStr( tn, "vending" ) )
    {
        r = "Pressione ^3[{+activate}]^7 para comprar " + ptbr_perk( tn );
        if ( isDefined( stub.zombie_cost ) && int( stub.zombie_cost ) == 0 )
            r = "Voce precisa de uma fonte de energia!";
    }

    // PERKS - specialty_ em script_string
    if ( !isDefined( r ) && isSubStr( ss, "specialty_" ) )
    {
        r = "Pressione ^3[{+activate}]^7 para comprar " + ptbr_perk( ss );
        if ( isDefined( stub.zombie_cost ) && int( stub.zombie_cost ) == 0 )
            r = "Voce precisa de uma fonte de energia!";
    }

    // ARMAS NA PAREDE
    if ( !isDefined( r ) && isDefined( stub.zombie_weapon_upgrade ) )
    {
        wpn = stub.zombie_weapon_upgrade;
        r = "Pressione ^3[{+activate}]^7 para " + ptbr_wn( wpn ) + " [Custo: " + ptbr_wc( wpn ) + "]";
        ptbr_wallbuy_register( stub );
        if ( isDefined( stub.trigger ) ) ptbr_wallbuy_register( stub.trigger );
    }

    // BARREIRAS por nome
    if ( !isDefined( r ) && ( isSubStr( sn, "barrier" ) || isSubStr( sn, "board" ) ||
         isSubStr( sn, "window" ) || isSubStr( sn, "rebuild" ) || isSubStr( sn, "zcb" ) ||
         isSubStr( sn, "blocker" ) || isSubStr( tn, "barrier" ) || isSubStr( tn, "board" ) ||
         isSubStr( tn, "window" ) || isSubStr( tn, "zcb" ) || isSubStr( tn, "rebuild" ) ||
         isSubStr( tn, "fix_boards" ) || isSubStr( sn, "fix_boards" ) ||
         isSubStr( tn, "rebuild_trigger" ) || isSubStr( sn, "rebuild_trigger" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";

    // PECAS / BUILDABLES
    if ( !isDefined( r ) && ( isSubStr( tn, "grab_item" ) || tn == "zombie_grab_item" ) )
        r = "Pressione ^3[{+activate}]^7 para Peca";
    if ( !isDefined( r ) )
    {
        eq = ""; if ( isDefined( stub.equipname ) ) eq = "" + stub.equipname;
        bz = ""; if ( isDefined( stub.buildablezone ) ) bz = "" + stub.buildablezone;
        if ( eq != "" || bz != "" )
            r = "Pressione ^3[{+activate}]^7 para Peca";
    }

    // PELO TEXTO DO HINT (ultima chance)
    if ( !isDefined( r ) && hs != "" )
    {
        if      ( isSubStr( hsl, "incorrect" ) || isSubStr( hsl, "wrong part" ) )
            r = "Peca incorreta";
        else if ( isSubStr( hsl, "additional" ) || isSubStr( hsl, "parts required" ) )
            r = "Pecas adicionais necessarias";
        else if ( isSubStr( hsl, "for part" ) || isSubStr( hsl, "pick up part" ) )
            r = "Pressione ^3[{+activate}]^7 para Peca";
        else if ( isSubStr( hsl, "place part" ) || isSubStr( hsl, "add part" ) )
            r = "Pressione ^3[{+activate}]^7 para colocar Peca";
        else if ( isSubStr( hsl, "to build" ) || isSubStr( hsl, "to craft" ) )
            r = "Pressione ^3[{+activate}]^7 para Construir";
        else if ( isSubStr( hsl, "rebuild" ) || isSubStr( hsl, "barrier" ) )
            r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";
        else if ( isSubStr( hsl, "source of power" ) || isSubStr( hsl, "need power" ) )
            r = "Voce precisa de uma fonte de energia!";
        else if ( isSubStr( hsl, "reviving" ) )
            r = "Reanimando...";
        else if ( isSubStr( hsl, "revive" ) )
        {
            cs = ptbr_cc( hs ); if ( cs == "" ) cs = "1500";
            r = "Pressione ^3[{+activate}]^7 para Quick Revive [Custo: " + cs + "]";
        }
        else if ( isSubStr( hsl, "pack" ) && isSubStr( hsl, "punch" ) )
            r = "Pressione ^3[{+activate}]^7 para Pack-a-Punch [Custo: 5000]";
        else if ( isSubStr( hsl, "mystery box" ) || isSubStr( hsl, "magic box" ) )
            r = "Pressione ^3[{+activate}]^7 para Caixa Misteriosa [Custo: 950]";
        else if ( isSubStr( hsl, "for equipment" ) )
            r = "Pressione ^3[{+activate}]^7 para Equipamento [Custo: 500]";
        else if ( isSubStr( hsl, "for ammo" ) || isSubStr( hsl, "buy ammo" ) )
            r = "Pressione ^3[{+activate}]^7 para Municao";
        else if ( isSubStr( hsl, " for " ) && isSubStr( hsl, "[cost:" ) && !isSubStr( hsl, "part" ) && !isSubStr( hsl, "equipment" ) )
        {
            wn = ptbr_wn( hsl ); cs = ptbr_cc( hs );
            if ( cs != "" )
            {
                if ( wn != "Arma" ) r = "Pressione ^3[{+activate}]^7 para " + wn + " [Custo: " + cs + "]";
                else r = "Pressione ^3[{+activate}]^7 para Comprar [Custo: " + cs + "]";
            }
        }
        else if ( isSubStr( hsl, "to open" ) )
        {
            cs = ""; if ( isDefined( stub.zombie_cost ) ) cs = " [Custo: " + stub.zombie_cost + "]";
            r = "Pressione ^3[{+activate}]^7 para Abrir" + cs;
        }
        else if ( ( isSubStr( hsl, "hold" ) || isSubStr( hsl, "press" ) ) &&
                  ( isSubStr( hsl, " to " ) || isSubStr( hsl, " for " ) ) )
            r = "Pressione ^3[{+activate}]^7";
    }

    if ( isDefined( r ) )
    {
        stub._ptbr_text = r;
        stub.hint_string = r;
        if ( isDefined( stub.trigger ) )
        {
            stub.trigger._ptbr_text = r;
            stub.trigger SetHintString( r );
            ptbr_wallbuy_register( stub.trigger );
        }
    }
}

// =====================================================
// SCAN PRINCIPAL - todos os triggers standard
// =====================================================
ptbr_scan()
{
    n = 0;
    n += ptbr_scan_class( "trigger_use" );
    n += ptbr_scan_class( "trigger_use_touch" );
    n += ptbr_scan_class( "trigger_multiple" );
    n += ptbr_scan_class( "trigger_radius" );
    return n;
}

ptbr_scan_class( cn )
{
    n = 0;
    a = getentarray( cn, "classname" );
    for ( i = 0; i < a.size; i++ )
        if ( ptbr_do( a[i] ) ) n++;
    return n;
}

// =====================================================
// ptbr_do - traduz um trigger standard
// =====================================================
ptbr_do( t )
{
    h   = ""; if ( isDefined( t.hintstring ) ) h = "" + t.hintstring;

    // Prioridade maxima: traduz hint raw antes de re-apply antigo
    rr = ptbr_translate_raw_hint( h, t );
    if ( isDefined( rr ) )
    {
        t._ptbr_text = rr;
        t SetHintString( rr );
        return true;
    }

    // Re-apply continuo
    if ( isDefined( t._ptbr_text ) )
    {
        if ( t._ptbr_text == "" )
            t._ptbr_text = undefined;
        else
        {
            if ( isDefined( t.zombie_weapon_upgrade ) && ptbr_player_has_weapon( "" + t.zombie_weapon_upgrade ) ) return true;
            t SetHintString( t._ptbr_text );
            return true;
        }
    }

    tn  = ""; if ( isDefined( t.targetname ) )         tn  = t.targetname;
    sn  = ""; if ( isDefined( t.script_noteworthy ) )  sn  = t.script_noteworthy;
    tg  = ""; if ( isDefined( t.target ) )             tg  = t.target;
    ss  = ""; if ( isDefined( t.script_string ) )      ss  = t.script_string;
    tnl = toLower( tn );
    snl = toLower( sn );
    tgl = toLower( tg );
    ssl = toLower( ss );
    hl  = toLower( h );

    r = undefined;

    // =================================================
    // BLOCO 1: PORTAS (zombie_door)
    // =================================================
    if ( !isDefined( r ) && tn == "zombie_door" )
    {
        if ( isSubStr( snl, "electric" ) || isSubStr( snl, "local_electric" ) )
            r = "Voce precisa de uma fonte de energia!";
        else
        {
            cs = ""; if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) > 0 ) cs = " [Custo: " + t.zombie_cost + "]";
            r = "Pressione ^3[{+activate}]^7 para abrir Porta" + cs;
        }
    }

    // =================================================
    // BLOCO 2: ENTULHO / DEBRIS
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "zombie_debris" ) || isSubStr( tnl, "rubble" ) ||
         isSubStr( snl, "debris" ) || isSubStr( tnl, "debris" ) ) )
    {
        cs = ""; if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) > 0 ) cs = " [Custo: " + t.zombie_cost + "]";
        r = "Pressione ^3[{+activate}]^7 para remover Entulho" + cs;
    }

    // =================================================
    // BLOCO 3: PACK-A-PUNCH (antes de armas)
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "pack_a_punch" ) || isSubStr( snl, "pack_a_punch" ) ||
         isSubStr( tnl, "pap" ) || isSubStr( tnl, "oupgrade" ) ||
         isSubStr( tgl, "pack_a_punch" ) || isSubStr( tgl, "pap_" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Pack-a-Punch [Custo: 5000]";

    if ( !isDefined( r ) && isSubStr( hl, "pack" ) && isSubStr( hl, "punch" ) )
        r = "Pressione ^3[{+activate}]^7 para Pack-a-Punch [Custo: 5000]";

    // =================================================
    // BLOCO 4: PERKS - zombie_vending_* targetname
    // =================================================
    if ( !isDefined( r ) && isSubStr( tnl, "vending" ) )
    {
        r = "Pressione ^3[{+activate}]^7 para comprar " + ptbr_perk( tnl + " " + snl + " " + ssl );
        if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) == 0 )
            r = "Voce precisa de uma fonte de energia!";
    }

    // PERKS - generic perk patterns
    if ( !isDefined( r ) && ( isSubStr( tnl, "perk_machine" ) || isSubStr( snl, "perk_" ) ||
         isSubStr( tgl, "vending" ) || isSubStr( tgl, "perk" ) ) )
    {
        r = "Pressione ^3[{+activate}]^7 para comprar " + ptbr_perk( snl + " " + tnl + " " + ssl );
        if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) == 0 )
            r = "Voce precisa de uma fonte de energia!";
    }

    // PERKS - specialty_ em script_string
    if ( !isDefined( r ) && isSubStr( ssl, "specialty_" ) )
    {
        r = "Pressione ^3[{+activate}]^7 para comprar " + ptbr_perk( ssl + " " + tnl + " " + snl );
        if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) == 0 )
            r = "Voce precisa de uma fonte de energia!";
    }

    // =================================================
    // BLOCO 5: ARMAS NA PAREDE
    // =================================================
    if ( !isDefined( r ) && ( tn == "weapon_upgrade" || isSubStr( tnl, "wallbuy" ) ||
         isSubStr( tnl, "wall_buy" ) || isSubStr( tnl, "wall_weapon" ) ) )
    {
        wpn = ""; if ( isDefined( t.zombie_weapon_upgrade ) ) wpn = t.zombie_weapon_upgrade;
        r = "Pressione ^3[{+activate}]^7 para " + ptbr_wn( wpn ) + " [Custo: " + ptbr_wc( wpn ) + "]";
        ptbr_wallbuy_register( t );
    }

    // Armas - campo zombie_weapon_upgrade direto
    if ( !isDefined( r ) && isDefined( t.zombie_weapon_upgrade ) )
    {
        wpn = t.zombie_weapon_upgrade;
        r = "Pressione ^3[{+activate}]^7 para " + ptbr_wn( wpn ) + " [Custo: " + ptbr_wc( wpn ) + "]";
        ptbr_wallbuy_register( t );
    }

    // =================================================
    // BLOCO 6: MUNICAO
    // =================================================
    if ( !isDefined( r ) && isSubStr( tnl, "ammo" ) && !isSubStr( tnl, "pack" ) )
    {
        cs = ""; if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) > 0 ) cs = " [Custo: " + t.zombie_cost + "]";
        r = "Pressione ^3[{+activate}]^7 para Municao" + cs;
    }

    // =================================================
    // BLOCO 7: CAIXA MISTERIOSA
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "treasure" ) || isSubStr( tnl, "magic_box" ) ||
         isSubStr( snl, "random" ) || isSubStr( snl, "moveable_chest" ) ||
         isSubStr( tnl, "chest_use" ) || isSubStr( tnl, "zbox" ) ||
         isSubStr( tgl, "treasure" ) || isSubStr( tgl, "magic_box" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Caixa Misteriosa [Custo: 950]";

    // =================================================
    // BLOCO 8: ENERGIA
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "powerswitch" ) || isSubStr( tnl, "elec_switch" ) ||
         isSubStr( tnl, "power_switch" ) || tn == "use_elec" || isSubStr( tnl, "electricswitch" ) ||
         ( isSubStr( tgl, "power" ) && !isSubStr( tgl, "powerup" ) ) ) )
        r = "Pressione ^3[{+activate}]^7 para Ligar a Energia";

    // =================================================
    // BLOCO 9: ONIBUS / TRANSPORTE
    // =================================================
    if ( !isDefined( r ) && isSubStr( tnl, "bus_door" ) )
        r = "Pressione ^3[{+activate}]^7 para Porta do Onibus";
    if ( !isDefined( r ) && ( isSubStr( tnl, "bus_horn" ) || isSubStr( snl, "horn" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Buzinar";
    if ( !isDefined( r ) && ( isSubStr( tnl, "bus_ride" ) || isSubStr( snl, "bus" ) ) )
        r = "Pressione ^3[{+activate}]^7 para embarcar no Onibus";

    // =================================================
    // BLOCO 10: ARMADILHAS
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "trap" ) || isSubStr( tnl, "zapper" ) ||
         isSubStr( snl, "trap" ) ) )
    {
        cs = ""; if ( isDefined( t.zombie_cost ) ) cs = " [Custo: " + t.zombie_cost + "]";
        r = "Pressione ^3[{+activate}]^7 para ativar Armadilha" + cs;
    }

    // =================================================
    // BLOCO 11: TELETRANSPORTE
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "teleport" ) || isSubStr( tgl, "teleport" ) ) )
        r = "Pressione ^3[{+activate}]^7 para usar Teletransporte";

    // =================================================
    // BLOCO 12: BUILDABLES / MESAS DE CONSTRUCAO
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "build_table" ) || isSubStr( tnl, "workbench" ) ||
         isSubStr( tnl, "bench_trigger" ) || isSubStr( tnl, "craft" ) ||
         isSubStr( tnl, "buildable" ) || isSubStr( snl, "craft" ) ||
         isSubStr( snl, "buildable" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Construir";

    // =================================================
    // BLOCO 13: PECAS
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "part_" ) || isSubStr( tnl, "pickup_" ) ||
         isSubStr( snl, "_part" ) || isSubStr( tnl, "grab_item" ) ||
         tnl == "zombie_grab_item" ) )
        r = "Pressione ^3[{+activate}]^7 para Peca";

    // =================================================
    // BLOCO 14: BARREIRAS
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "board" ) || isSubStr( tnl, "barrier" ) ||
         isSubStr( snl, "board" ) || isSubStr( snl, "window" ) || isSubStr( snl, "barrier" ) ||
         isSubStr( tnl, "zombie_window" ) || isSubStr( snl, "barricade" ) ||
         isSubStr( tnl, "barricade" ) || isSubStr( snl, "zcb" ) || isSubStr( tnl, "zcb" ) ||
         isSubStr( snl, "blocker" ) || isSubStr( tnl, "blocker" ) ||
         isSubStr( snl, "rebuild" ) || isSubStr( tnl, "rebuild" ) ||
         isSubStr( tnl, "fix_boards" ) || isSubStr( snl, "fix_boards" ) ||
         isSubStr( tnl, "rebuild_trigger" ) || isSubStr( snl, "rebuild_trigger" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";

    // =================================================
    // BLOCO 14b: BARREIRA por proximidade de boards (script_model com "board" no model)
    // =================================================
    if ( !isDefined( r ) )
    {
        if ( !isDefined( level._ptbr_boards ) )
            level._ptbr_boards = getentarray( "script_model", "classname" );
        for ( _bi = 0; _bi < level._ptbr_boards.size; _bi++ )
        {
            if ( distance( t.origin, level._ptbr_boards[_bi].origin ) < 100 &&
                 isSubStr( toLower( level._ptbr_boards[_bi].model ), "board" ) )
            {
                r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";
                break;
            }
        }
    }

    // =================================================
    // BLOCO 15: ESPECIAIS (galva, bowie, bank, fridge, afterlife, etc)
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "galva" ) || isSubStr( snl, "galva" ) ) )
        r = "Pressione ^3[{+activate}]^7 para comprar Galvaknuckles [Custo: 6000]";
    if ( !isDefined( r ) && ( isSubStr( tnl, "bowie" ) || isSubStr( snl, "bowie" ) ) )
        r = "Pressione ^3[{+activate}]^7 para comprar Faca Bowie [Custo: 3000]";
    if ( !isDefined( r ) && ( isSubStr( tnl, "bank" ) || isSubStr( snl, "bank" ) ) )
        r = "Pressione ^3[{+activate}]^7 para acessar o Banco";
    if ( !isDefined( r ) && ( isSubStr( tnl, "fridge" ) || isSubStr( snl, "fridge" ) ) )
        r = "Pressione ^3[{+activate}]^7 para acessar a Geladeira";
    if ( !isDefined( r ) && ( isSubStr( tnl, "turbine" ) || isSubStr( snl, "turbine" ) ) )
        r = "Pressione ^3[{+activate}]^7 para colocar Turbina";
    if ( !isDefined( r ) && isSubStr( tnl, "gondola" ) )
    {
        cs = ""; if ( isDefined( t.zombie_cost ) ) cs = " [Custo: " + t.zombie_cost + "]";
        r = "Pressione ^3[{+activate}]^7 para chamar Gondola" + cs;
    }
    if ( !isDefined( r ) && isSubStr( tnl, "elevator" ) )
        r = "Pressione ^3[{+activate}]^7 para chamar Elevador";
    if ( !isDefined( r ) && isSubStr( tnl, "plane" ) )
        r = "Pressione ^3[{+activate}]^7 para voar com o Aviao";
    if ( !isDefined( r ) && ( isSubStr( tnl, "afterlife" ) || isSubStr( snl, "afterlife" ) ) )
        r = "Pressione ^3[{+activate}]^7 para entrar no Alem";
    if ( !isDefined( r ) && ( isSubStr( tnl, "staff_slot" ) || isSubStr( snl, "staff_slot" ) ) )
        r = "Pressione ^3[{+activate}]^7 para colocar Bastao";
    if ( !isDefined( r ) && ( isSubStr( tnl, "staff_pickup" ) || isSubStr( snl, "staff_pickup" ) ) )
        r = "Pressione ^3[{+activate}]^7 para pegar Bastao";
    if ( !isDefined( r ) && ( isSubStr( tnl, "soul_box" ) || isSubStr( snl, "soul_box" ) ||
         isSubStr( tnl, "soul_chest" ) ) )
        r = "Pressione ^3[{+activate}]^7 para ativar Caixa de Almas";
    if ( !isDefined( r ) && isSubStr( tnl, "navcard" ) )
        r = "Pressione ^3[{+activate}]^7 para pegar Cartao de Navegacao";
    if ( !isDefined( r ) && isSubStr( tnl, "weapon_grab" ) )
        r = "Pressione ^3[{+activate}]^7 para pegar Arma";

    // =================================================
    // BLOCO 16: EQUIPAMENTOS
    // =================================================
    if ( !isDefined( r ) && ( isSubStr( tnl, "equip" ) || isSubStr( snl, "equip" ) ||
         isSubStr( tnl, "tactical" ) || isSubStr( tnl, "lethal" ) ) )
    {
        cs = ""; if ( isDefined( t.zombie_cost ) && int( t.zombie_cost ) > 0 ) cs = " [Custo: " + t.zombie_cost + "]";
        else cs = " [Custo: 500]";
        r = "Pressione ^3[{+activate}]^7 para Equipamento" + cs;
    }

    // =================================================
    // BLOCO 17: CUSTO GENERICO
    // =================================================
    if ( !isDefined( r ) && isDefined( t.zombie_cost ) && int( t.zombie_cost ) > 0 )
        r = "Pressione ^3[{+activate}]^7 para comprar [Custo: " + t.zombie_cost + "]";

    // =================================================
    // BLOCO 18: FALLBACK PELO TEXTO DO HINT (quando legivel)
    // =================================================
    if ( !isDefined( r ) && h != "" )
    {
        if      ( isSubStr( hl, "incorrect part" ) || isSubStr( hl, "wrong part" ) )
            r = "Peca incorreta";
        else if ( isSubStr( hl, "additional parts" ) || isSubStr( hl, "parts required" ) )
            r = "Pecas adicionais necessarias";
        else if ( isSubStr( hl, "for part" ) || isSubStr( hl, "pick up part" ) )
            r = "Pressione ^3[{+activate}]^7 para Peca";
        else if ( isSubStr( hl, "place part" ) || isSubStr( hl, "add part" ) )
            r = "Pressione ^3[{+activate}]^7 para colocar Peca";
        else if ( isSubStr( hl, "to build" ) || isSubStr( hl, "to craft" ) || isSubStr( hl, "bench" ) )
            r = "Pressione ^3[{+activate}]^7 para Construir";
        else if ( isSubStr( hl, "building" ) || isSubStr( hl, "crafting" ) )
            r = "Construindo...";
        else if ( isSubStr( hl, "rebuild" ) || isSubStr( hl, "barrier" ) )
            r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";
        else if ( isSubStr( hl, "mystery box" ) || isSubStr( hl, "magic box" ) || isSubStr( hl, "random weapon" ) )
            r = "Pressione ^3[{+activate}]^7 para Caixa Misteriosa [Custo: 950]";
        else if ( isSubStr( hl, "for equipment" ) )
        {
            cs = ptbr_cc( h ); if ( cs != "" ) cs = " [Custo: " + cs + "]"; else cs = " [Custo: 500]";
            r = "Pressione ^3[{+activate}]^7 para Equipamento" + cs;
        }
        else if ( isSubStr( hl, "pack" ) && isSubStr( hl, "punch" ) )
            r = "Pressione ^3[{+activate}]^7 para Pack-a-Punch [Custo: 5000]";
        else if ( isSubStr( hl, "buy ammo" ) || isSubStr( hl, "for ammo" ) )
        {
            cs = ptbr_cc( h ); if ( cs != "" ) cs = " [Custo: " + cs + "]"; else cs = "";
            r = "Pressione ^3[{+activate}]^7 para Municao" + cs;
        }
        else if ( isSubStr( hl, "source of power" ) || isSubStr( hl, "need power" ) )
            r = "Voce precisa de uma fonte de energia!";
        else if ( isSubStr( hl, "turn on" ) || isSubStr( hl, "power on" ) )
            r = "Pressione ^3[{+activate}]^7 para Ligar a Energia";
        else if ( isSubStr( hl, "reviving" ) )
            r = "Reanimando...";
        else if ( isSubStr( hl, "revive" ) )
        {
            cs = ptbr_cc( h ); if ( cs == "" ) cs = "1500";
            r = "Pressione ^3[{+activate}]^7 para Quick Revive [Custo: " + cs + "]";
        }
        else if ( isSubStr( hl, "to close" ) )
            r = "Pressione ^3[{+activate}]^7 para Fechar";
        else if ( isSubStr( hl, "to open" ) )
        {
            cs = ptbr_cc( h ); if ( cs != "" ) r = "Pressione ^3[{+activate}]^7 para Abrir [Custo: " + cs + "]";
            else r = "Pressione ^3[{+activate}]^7 para Abrir";
        }
        else if ( isSubStr( hl, "not enough" ) || isSubStr( hl, "insufficient" ) )
            r = "Pontos insuficientes!";
        else if ( isSubStr( hl, "jugger" ) || isSubStr( hl, "jugg" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Juggernog [Custo: 2500]";
        else if ( isSubStr( hl, "speed cola" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Speed Cola [Custo: 3000]";
        else if ( isSubStr( hl, "double tap" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Double Tap [Custo: 2000]";
        else if ( isSubStr( hl, "stamin" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Stamin-Up [Custo: 2000]";
        else if ( isSubStr( hl, "deadshot" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Deadshot Daiquiri [Custo: 1500]";
        else if ( isSubStr( hl, "mule kick" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Mule Kick [Custo: 4000]";
        else if ( isSubStr( hl, "tombstone" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Tombstone Soda [Custo: 2000]";
        else if ( isSubStr( hl, "who" ) && isSubStr( hl, "who" ) && isSubStr( hl, "2000" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Who's Who [Custo: 2000]";
        else if ( isSubStr( hl, "electric cherry" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Electric Cherry [Custo: 2000]";
        else if ( isSubStr( hl, "vulture" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Vulture Aid [Custo: 3000]";
        else if ( isSubStr( hl, "phd" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar PHD Flopper [Custo: 2000]";
        else if ( isSubStr( hl, "galva" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Galvaknuckles [Custo: 6000]";
        else if ( isSubStr( hl, "bowie" ) )
            r = "Pressione ^3[{+activate}]^7 para comprar Faca Bowie [Custo: 3000]";
        else if ( isSubStr( hl, " for " ) && isSubStr( hl, "[cost:" ) && !isSubStr( hl, "part" ) && !isSubStr( hl, "equipment" ) )
        {
            wn = ptbr_wn( hl ); cs = ptbr_cc( h );
            if ( cs != "" )
            {
                if ( wn != "Arma" ) r = "Pressione ^3[{+activate}]^7 para " + wn + " [Custo: " + cs + "]";
                else r = "Pressione ^3[{+activate}]^7 para Comprar [Custo: " + cs + "]";
            }
        }
        if ( !isDefined( r ) && ( isSubStr( hl, "hold " ) || isSubStr( hl, "press " ) ) &&
             ( isSubStr( hl, " to " ) || isSubStr( hl, " for " ) ) )
            r = "Pressione ^3[{+activate}]^7";
    }

    // ULTIMO RECURSO: re-le hintstring e testa padroes dos 5 casos problematicos
    if ( !isDefined( r ) )
    {
        h2 = ""; if ( isDefined( t.hintstring ) ) h2 = "" + t.hintstring;
        hl2 = toLower( h2 );
        if ( h2 != "" )
        {
            if      ( isSubStr( hl2, "revive" ) && !isSubStr( hl2, "reviving" ) )
            {
                cs = ptbr_cc( h2 ); if ( cs == "" ) cs = "500";
                r = "Pressione ^3[{+activate}]^7 para Quick Revive [Custo: " + cs + "]";
            }
            else if ( isSubStr( hl2, "for part" ) || isSubStr( hl2, "grab part" ) )
                r = "Pressione ^3[{+activate}]^7 para Peca";
            else if ( isSubStr( hl2, "additional part" ) || isSubStr( hl2, "parts required" ) )
                r = "Pecas adicionais necessarias";
            else if ( isSubStr( hl2, "rebuild" ) || isSubStr( hl2, "repair barrier" ) )
                r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";
            else if ( isSubStr( hl2, "hold " ) && isSubStr( hl2, "cost" ) )
            {
                wn = ptbr_wn( h2 ); cs = ptbr_cc( h2 );
                if ( cs != "" )
                {
                    if ( wn != "Arma" ) r = "Pressione ^3[{+activate}]^7 para " + wn + " [Custo: " + cs + "]";
                    else r = "Pressione ^3[{+activate}]^7 para Comprar [Custo: " + cs + "]";
                }
            }
        }
    }

    if ( isDefined( r ) )
    {
        t._ptbr_text = r;
        t SetHintString( r );
        return true;
    }
    return false;
}

// =====================================================
// HELPERS
// =====================================================

ptbr_translate_raw_hint( h, ent )
{
    if ( !isDefined( h ) || h == "" ) return undefined;

    h = ptbr_norm_hint( h );
    hl = toLower( h );
    if ( isSubStr( hl, "pressione" ) || isSubStr( hl, "segure" ) || isSubStr( hl, "peca" ) || isSubStr( hl, "pecas" ) )
        return undefined;

    r = undefined;
    cs = ptbr_cc( h );

    // 7) Additional Parts required
    if ( !isDefined( r ) && ( isSubStr( hl, "additional parts required" ) ||
         ( isSubStr( hl, "additional" ) && isSubStr( hl, "parts required" ) ) ) )
        r = "Pecas adicionais necessarias";

    // 8) You need power first!
    if ( !isDefined( r ) && ( isSubStr( hl, "you need power first" ) || isSubStr( hl, "need power" ) || isSubStr( hl, "source of power" ) ) )
        r = "Voce precisa de uma fonte de energia!";

    // 6) Hold F for Revive [Cost: N]
    if ( !isDefined( r ) && isSubStr( hl, "hold" ) && isSubStr( hl, " for revive" ) && !isSubStr( hl, "reviving" ) )
    {
        if ( cs == "" ) cs = "500";
        r = "Pressione ^3[{+activate}]^7 para Quick Revive [Custo: " + cs + "]";
    }

    // 5) Hold F for Part
    if ( !isDefined( r ) && isSubStr( hl, "hold" ) && ( isSubStr( hl, " for part" ) || isSubStr( hl, " grab part" ) ) )
        r = "Pressione ^3[{+activate}]^7 para Peca";

    // 4) Hold F to rebuild Barrier
    if ( !isDefined( r ) && isSubStr( hl, "hold" ) && isSubStr( hl, "rebuild" ) && isSubStr( hl, "barrier" ) )
        r = "Pressione ^3[{+activate}]^7 para Consertar Barreira";

    // 9) Hold F to open Door [Cost: N]
    if ( !isDefined( r ) && isSubStr( hl, "hold" ) && isSubStr( hl, " to open" ) && isSubStr( hl, "door" ) )
    {
        if ( isSubStr( hl, "bus" ) )
            r = "Pressione ^3[{+activate}]^7 para Porta do Onibus";
        else if ( cs != "" )
            r = "Pressione ^3[{+activate}]^7 para abrir Porta [Custo: " + cs + "]";
        else
            r = "Pressione ^3[{+activate}]^7 para abrir Porta";
    }

    // 1/2/10/11) Hold F for <item> [Cost:N] e Hold F for <item>
    if ( !isDefined( r ) && isSubStr( hl, "hold" ) && isSubStr( hl, " for " ) )
    {
        item = ptbr_extract_hold_for_item( h );
        il = toLower( item );
        if ( item != "" )
        {
            if ( isSubStr( il, "part" ) )
                r = "Pressione ^3[{+activate}]^7 para Peca";
            else if ( isSubStr( il, "revive" ) )
            {
                if ( cs == "" ) cs = "500";
                r = "Pressione ^3[{+activate}]^7 para Quick Revive [Custo: " + cs + "]";
            }
            else
            {
                wn = ptbr_wn( item );
                if ( wn == "Arma" ) wn = ptbr_wn( h );
                if ( wn == "Arma" || wn == "" ) wn = item;
                if ( isSubStr( il, "olympia" ) ) wn = "Olympia";
                if ( isSubStr( il, "m14" ) ) wn = "M14";
                if ( cs != "" ) r = "Pressione ^3[{+activate}]^7 para " + wn + " [Custo: " + cs + "]";
                else r = "Pressione ^3[{+activate}]^7 para " + wn;
            }
        }
    }

    // 3) Hold F to <action> <target>
    if ( !isDefined( r ) && isSubStr( hl, "hold" ) && isSubStr( hl, " to " ) )
        r = "Pressione ^3[{+activate}]^7 para Interagir";

    if ( !isDefined( r ) && ( isSubStr( hl, "hold" ) || isSubStr( hl, "additional" ) || isSubStr( hl, "need power" ) || isSubStr( hl, "cost:" ) ) )
    {
        // hint nao reconhecido - sem acao
    }

    if ( isDefined( r ) && isDefined( ent ) )
        ptbr_wallbuy_register( ent );

    return r;
}

ptbr_find_ci( s, token )
{
    ls = toLower( s );
    lt = toLower( token );
    if ( lt == "" ) return -1;
    for ( i = 0; i <= ls.size - lt.size; i++ )
        if ( getSubStr( ls, i, i + lt.size ) == lt ) return i;
    return -1;
}

ptbr_replace_all( s, old, neo )
{
    if ( old == "" ) return s;
    o = toLower( old );
    r = s;
    while ( true )
    {
        lr = toLower( r );
        i = ptbr_find_ci( lr, o );
        if ( i < 0 ) break;
        a = getSubStr( r, 0, i );
        b = getSubStr( r, i + old.size, r.size );
        r = a + neo + b;
    }
    return r;
}

ptbr_collapse_spaces( s )
{
    r = "";
    last = false;
    for ( i = 0; i < s.size; i++ )
    {
        ch = getSubStr( s, i, i + 1 );
        if ( ch == " " )
        {
            if ( !last )
            {
                r += " ";
                last = true;
            }
        }
        else
        {
            r += ch;
            last = false;
        }
    }
    return ptbr_trim( r );
}

ptbr_norm_hint( s )
{
    if ( !isDefined( s ) ) return "";
    r = "" + s;
    r = ptbr_replace_all( r, "^1", "" );
    r = ptbr_replace_all( r, "^2", "" );
    r = ptbr_replace_all( r, "^3", "" );
    r = ptbr_replace_all( r, "^4", "" );
    r = ptbr_replace_all( r, "^5", "" );
    r = ptbr_replace_all( r, "^6", "" );
    r = ptbr_replace_all( r, "^7", "" );
    r = ptbr_replace_all( r, "[{+activate}]", "F" );
    r = ptbr_replace_all( r, "{+activate}", "F" );
    r = ptbr_replace_all( r, "[", " " );
    r = ptbr_replace_all( r, "]", " " );
    return ptbr_collapse_spaces( r );
}

ptbr_trim( s )
{
    st = 0;
    en = s.size;
    while ( st < en && getSubStr( s, st, st + 1 ) == " " ) st++;
    while ( en > st && getSubStr( s, en - 1, en ) == " " ) en--;
    return getSubStr( s, st, en );
}

ptbr_extract_hold_for_item( h )
{
    hl = toLower( h );
    i = ptbr_find_ci( hl, " for " );
    if ( i < 0 ) return "";

    st = i + 5;
    en = h.size;
    j = ptbr_find_ci( hl, " [cost:" );
    if ( j >= 0 && j > st ) en = j;
    k = ptbr_find_ci( hl, " [custo:" );
    if ( k >= 0 && k > st && k < en ) en = k;
    return ptbr_trim( getSubStr( h, st, en ) );
}

// ptbr_player_has_weapon(wpn) - verifica se algum jogador vivo ja possui a arma
ptbr_player_has_weapon( wpn )
{
    _players = getplayers();
    for ( _pi = 0; _pi < _players.size; _pi++ )
        if ( isAlive( _players[_pi] ) && _players[_pi] hasWeapon( wpn ) ) return true;
    return false;
}

// ptbr_perk(s) - retorna nome + custo do perk baseado em string de identifiers
ptbr_perk( s )
{
    sl = toLower( s );
    if ( isSubStr( sl, "jugg" ) )
        return "Juggernog [Custo: 2500]";
    if ( isSubStr( sl, "doubletap" ) || isSubStr( sl, "double_tap" ) || isSubStr( sl, "rof" ) )
        return "Double Tap [Custo: 2000]";
    if ( isSubStr( sl, "speed" ) || isSubStr( sl, "fastreload" ) || isSubStr( sl, "sleight" ) )
        return "Speed Cola [Custo: 3000]";
    if ( isSubStr( sl, "quickrevive" ) || isSubStr( sl, "revive" ) )
        return "Quick Revive [Custo: 1500]";
    if ( isSubStr( sl, "phd" ) || isSubStr( sl, "flopper" ) )
        return "PHD Flopper [Custo: 2000]";
    if ( isSubStr( sl, "stamin" ) || isSubStr( sl, "marathon" ) || isSubStr( sl, "longersprint" ) )
        return "Stamin-Up [Custo: 2000]";
    if ( isSubStr( sl, "deadshot" ) || isSubStr( sl, "deadaim" ) )
        return "Deadshot Daiquiri [Custo: 1500]";
    if ( isSubStr( sl, "widow" ) )
        return "Widow's Wine [Custo: 4000]";
    if ( isSubStr( sl, "mule" ) || isSubStr( sl, "additionalprimary" ) )
        return "Mule Kick [Custo: 4000]";
    if ( isSubStr( sl, "electric_cherry" ) || isSubStr( sl, "cherry" ) || isSubStr( sl, "electriccherry" ) )
        return "Electric Cherry [Custo: 2000]";
    if ( isSubStr( sl, "vulture" ) || isSubStr( sl, "yourwayout" ) )
        return "Vulture Aid [Custo: 3000]";
    if ( isSubStr( sl, "tombstone" ) )
        return "Tombstone Soda [Custo: 2000]";
    if ( isSubStr( sl, "chugabud" ) || isSubStr( sl, "whos" ) || isSubStr( sl, "whowho" ) )
        return "Who's Who [Custo: 2000]";
    return "Perk";
}

// ptbr_cc(s) - extrai custo numerico de uma string
ptbr_cc( s )
{
    if(isSubStr(s,"16000"))return"16000"; if(isSubStr(s,"10000"))return"10000";
    if(isSubStr(s,"7500"))return"7500";   if(isSubStr(s,"6000"))return"6000";
    if(isSubStr(s,"5000"))return"5000";   if(isSubStr(s,"4000"))return"4000";
    if(isSubStr(s,"3000"))return"3000";   if(isSubStr(s,"2500"))return"2500";
    if(isSubStr(s,"2000"))return"2000";   if(isSubStr(s,"1750"))return"1750";
    if(isSubStr(s,"1500"))return"1500";   if(isSubStr(s,"1250"))return"1250";
    if(isSubStr(s,"1000"))return"1000";   if(isSubStr(s,"950"))return"950";
    if(isSubStr(s,"750"))return"750";     if(isSubStr(s,"500"))return"500";
    if(isSubStr(s,"250"))return"250";     if(isSubStr(s,"200"))return"200";
    if(isSubStr(s,"100"))return"100";
    return "";
}

// ptbr_wn(w) - nome PT-BR da arma
ptbr_wn( w )
{
    r = toLower( w );
    if(r==""||r=="yourpart_wallweapon") return "Arma";
    if(isSubStr(r,"m14"))      return "M14";
    if(isSubStr(r,"olympia"))  return "Olympia";
    if(isSubStr(r,"b23r")||isSubStr(r,"beretta")) return "B23R";
    if(isSubStr(r,"mp5"))      return "MP5K";
    if(isSubStr(r,"ak74"))     return "AK-74u";
    if(isSubStr(r,"pdw"))      return "PDW-57";
    if(isSubStr(r,"m16"))      return "M16";
    if(isSubStr(r,"galil"))    return "Galil";
    if(isSubStr(r,"famas"))    return "FAMAS";
    if(isSubStr(r,"aug"))      return "AUG";
    if(isSubStr(r,"fal"))      return "FAL";
    if(isSubStr(r,"rpd"))      return "RPD";
    if(isSubStr(r,"hk21"))     return "HK21";
    if(isSubStr(r,"python"))   return "Python";
    if(isSubStr(r,"cz75"))     return "CZ75";
    if(isSubStr(r,"spas"))     return "SPAS-12";
    if(isSubStr(r,"hs10"))     return "HS10";
    if(isSubStr(r,"pm63"))     return "PM63";
    if(isSubStr(r,"spectre"))  return "Spectre";
    if(isSubStr(r,"stakeout")) return "Stakeout";
    if(isSubStr(r,"ray_gun_mark2")||isSubStr(r,"raygun2")) return "Ray Gun Mark II";
    if(isSubStr(r,"ray_gun")||isSubStr(r,"raygun"))        return "Ray Gun";
    if(isSubStr(r,"hamr"))     return "HAMR";
    if(isSubStr(r,"type25")||isSubStr(r,"type_25")) return "Type 25";
    if(isSubStr(r,"dsr"))      return "DSR-50";
    if(isSubStr(r,"chicom"))   return "Chicom CQB";
    if(isSubStr(r,"mtar"))     return "MTAR";
    if(isSubStr(r,"svu"))      return "SVU-AS";
    if(isSubStr(r,"ballista")) return "Ballista";
    if(isSubStr(r,"an94")||isSubStr(r,"an_94")) return "AN-94";
    if(isSubStr(r,"lsat"))     return "LSAT";
    if(isSubStr(r,"ksg"))      return "KSG";
    if(isSubStr(r,"s12")||isSubStr(r,"saiga")) return "S12";
    if(isSubStr(r,"870")||isSubStr(r,"remington")) return "R-870 MCS";
    if(isSubStr(r,"smr"))      return "SMR";
    if(isSubStr(r,"vector"))   return "Vector K10";
    if(isSubStr(r,"msmc"))     return "MSMC";
    if(isSubStr(r,"m8a1"))     return "M8A1";
    if(isSubStr(r,"m27"))      return "M27";
    if(isSubStr(r,"mp40"))     return "MP40";
    if(isSubStr(r,"thompson")||isSubStr(r,"m1927")) return "Thompson";
    if(isSubStr(r,"crossbow")) return "Besta Explosiva";
    if(isSubStr(r,"ballistic_knife")) return "Faca Balistica";
    if(isSubStr(r,"claymore")) return "Claymore";
    if(isSubStr(r,"bouncing_betty")||isSubStr(r,"betty")) return "Bouncing Betty";
    if(isSubStr(r,"cymbal_monkey")||isSubStr(r,"monkey")) return "Macaco-Cimbalos";
    if(isSubStr(r,"semtex"))   return "Semtex";
    if(isSubStr(r,"frag"))     return "Granada";
    // Fallback: getweapondisplayname para codenames nao mapeados
    if ( !isSubStr( r, " " ) && !isSubStr( r, "[" ) )
    {
        dn = getweapondisplayname( w );
        if ( isDefined( dn ) && dn != "" ) return dn;
    }
    name = w;
    if ( name.size > 3 && getSubStr( name, name.size - 3, name.size ) == "_zm" )
        name = getSubStr( name, 0, name.size - 3 );
    return name;
}

// ptbr_wc(w) - custo da arma na parede
ptbr_wc( w )
{
    r = toLower( w );
    if(isSubStr(r,"m14")||isSubStr(r,"olympia")||isSubStr(r,"ballista")) return "500";
    if(isSubStr(r,"b23r")||isSubStr(r,"beretta")||isSubStr(r,"mp5")||isSubStr(r,"pdw")) return "1000";
    if(isSubStr(r,"ak74")||isSubStr(r,"870")||isSubStr(r,"remington")) return "1200";
    if(isSubStr(r,"an94")||isSubStr(r,"an_94")||isSubStr(r,"fal")||isSubStr(r,"mtar")||isSubStr(r,"type25")) return "1200";
    if(isSubStr(r,"m8a1")||isSubStr(r,"m27")||isSubStr(r,"msmc")) return "1200";
    if(isSubStr(r,"mp40")||isSubStr(r,"chicom")) return "1300";
    if(isSubStr(r,"m16")||isSubStr(r,"galil")||isSubStr(r,"thompson")||isSubStr(r,"m1927")) return "1500";
    if(isSubStr(r,"hamr")||isSubStr(r,"smr")||isSubStr(r,"vector")) return "1500";
    if(isSubStr(r,"aug")||isSubStr(r,"famas")) return "1500";
    if(isSubStr(r,"lsat")||isSubStr(r,"rpd")||isSubStr(r,"hk21")) return "2000";
    if(isSubStr(r,"spas")||isSubStr(r,"hs10")||isSubStr(r,"ksg")||isSubStr(r,"s12")) return "1500";
    if(isSubStr(r,"stakeout")) return "1500";
    if(isSubStr(r,"bowie")) return "3000";
    if(isSubStr(r,"galva")) return "6000";
    return "???";
}
