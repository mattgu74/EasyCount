

import nostdlib.tablebuilder


User_View_Account = {{
    
    
    /**
    Get all groups the current user is in.
    */
    @publish
    get_all_groups() =
    (
        ref = User.current_user_ref()
        Option.switch(
            user -> user.groups
            ,
            [],
            User_Data.get(ref)
        )
    )
    
    /**
    Compute the table of current-user's groups.
    @return table a TableBuilder.t
    */
    @client
    table_groups() : TableBuilder.t(string) =
    (
        columns = [
            TableBuilder.mk_column(
                <>Groupe</>,
                r,_c -> <a href="/group/view/{r}">{r}</a>,
                some(r1, r2 -> String.ordering(r1, r2)),
                none
            )
        ]
        spec = TableBuilder.mk_spec(columns, get_all_groups())
        TableBuilder.make(spec)
    )
    
    
    /**
    Add a group to the table.
    @param table the table
    @param group the group to add
    */
    table_add_group(table : TableBuilder.t(string))(group : Group.t) : void =
    (
        TableBuilder.add(table.channel, group.name)
    )
    
    
    /**
    The view of the account.
    @return xhtml
    */
    html() : xhtml =
    (
        xhtml() = 
        (
            table = table_groups()
            (<>
            <h1>My Account</h1>
            <p>Welcome {User.current_user_ref()}.</p>
            <h3>Create a new group</h3>
            <ul>
                <li>Create a group</li>
                <li>Invite people</li>
                <li>Manage your acounts</li>
            </ul>
            {NewGroupForm.show(table_add_group(table))}
            <h3>My groups</h3>
            {table.xhtml}
            </>)
        )
        
        <div id=#content onready={_->Dom.transform([#content <- xhtml()])}></div>
    )




}}
