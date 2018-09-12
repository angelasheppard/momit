recruitment_board = Thredded::Messageboard.find_by(name: 'Recruitment')
unless recruitment_board.nil?
    new_topic = Thredded::Topic.new( messageboard_id: recruitment_board.id,
                                 title: 'Applying to MOMiT',
                                 sticky: true,
                                 locked: false,
                                 moderation_state: 'approved'
                                )

    if new_topic.save!
        Log.info('SEED', "Created Topic(#{new_topic.id}) - #{new_topic.title}")
        post_content = "#### So you're thinking about becoming a member...

        That's great! Clearly you have the discernment and good sense we're looking for in our fellow members. Here's how to go about it.

        MOMIT requires an application before being invited into the guild. For those who might find this to be too formal a step, think of this not so much as an application as a starting point for a more detailed conversation. We want to get to know you, and we want you to know more about us -- this is where we begin that process.

        ##### Step 1: Apply
        Fill out the Application Form (the next post) and create a new thread in the [Recruitment forum](../forum/recruitment). It'll save us a step if you make sure your name and class and spec are in the title.

        An Officer or the Admin will respond to your post and let you know that we've received the application. At that point, the Recruitment Officer will reply to you (most likely via private message on this forum) to arrange a time to discuss your application. During that conversation, we will ask you questions! This is also your chance to ask us questions. You can also feel free to message an Officer or Admin in-game if there's anything you want to know -- that's what we're there for -- or even approach any of our members to get the 'real scoop' on the guild. We run a pretty transparent ship here, and we trust our members to be our strongest advocates.

        If you are interested in raiding with us, we'll generally recommend that you listen in on one of our raids before committing to anything as potentially expensive as a server transfer. We've also invited people to join us cross-realm, if they'd prefer. If, after these conversations, we both think this will be a good fit, the Recruitment Officer will extend a /ginvite and you will join the guild as an Initiate.

        Please note that we are committed to the community of Aerie Peak; therefore, if you have left your previous guild on bad terms, this will be considered a major red flag on your application. Specific circumstances can be discussed on a case-by-case basis with the Recruitment Officer.

        _**Please do not server transfer until you have talked with us about your application!**_

        ##### Step 2: Let's Get to Know Each Other**
        The Initiate period will always last for at least three weeks, and can extend as long as you like. When you've been around for a while, seen how we do things, and we've had a chance to meet you, then you can decide that you want to become a full-fledged Member. At that point, simply let the Recruitment Officer know about your intentions.

        ##### Step 3: Democracy in Action**
        When an Initiate joins, a private thread in the Members forum is created. In that thread the people you've been hanging out with will vote on whether or not to invite you into the guild as a full Member.

        **The First Week**
        Membership voting threads will be locked for the first week of your application. This is mostly to ensure that you are given a fair chance to acclimate before anyone begins scrutinizing you too closely. 'No' votes WILL be accepted during this time - they'll need to be PMed to a Steward and they'll be tracked until the thread opens.

        Throughout the voting process, if we receive a No vote (anonymously or otherwise) one of the Stewards will note that fact in the voting thread.

        **The Next Two Weeks**
        The next two weeks will be the membership voting period. These voting threads are part of a dialogue, and are entered into with that mindset. They should also be based on more than one interaction with you -- we're trying to observe a pattern of behavior rather than any single incident.

        **Extension**
        After three weeks, once you've contacted a Steward to let us know you're interested in becoming a full member, we'll have a conversation regarding your voting thread. This will be a chance for you to learn of and address any issues people might be having, or it might simply be a case of 'keep running stuff and eventually someone will get off their lazy butts and vote.' We will do our best to have one of these discussions for every week the vote is extended beyond the initial three weeks.

        It currently requires eight 'Yes' votes to become a Member. Four 'No' votes will result in the Initiate being asked to leave and find another guild where they might be a better fit. Just so you're prepared, even though the formal period is three weeks we generally expect this process to take about a month.

        If an Initiate receives the approving votes before the end of the introductory period, they will be promoted to Member upon completion of the three weeks and the voting will be closed. Hooray!

        After that introductory three-week period, an Initiate who desires membership will be automatically promoted to Member upon receiving their required approvals. The voting will then be closed. Also Hooray!
        "
        post_content.gsub!(/\n\s{4,}/, "\n")

        new_post = Thredded::Post.new( content: post_content,
                                       messageboard_id: recruitment_board.id,
                                       postable_id: new_topic.id,
                                       moderation_state: 'approved'
                                     )
        if new_post.save!
            Log.info('SEED', "Created Post(#{new_post.id}) in Topic(#{new_topic.title})")
            new_topic.update_attributes(locked: true)
        else
            Log.notice('SEED', "Failed to create Post in Topic(#{new_post.postable_id}), #{new_post.errors.full_messages}")
        end
    else
        Log.notice('SEED', "Failed to create Topic(#{new_topic.title}), #{new_topic.errors.full_messages}")
    end
end