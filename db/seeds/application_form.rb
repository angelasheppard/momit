recruitment_board = Thredded::Messageboard.find_by(name: 'Recruitment')
unless recruitment_board.nil?
    new_topic = Thredded::Topic.new( messageboard_id: recruitment_board.id,
                                 title: 'Application Form',
                                 sticky: true,
                                 locked: false,
                                 moderation_state: 'approved'
                                )

    if new_topic.save!
        Log.info('SEED', "Created Topic(#{new_topic.id}) - #{new_topic.title}")
        post_content = "#### APPLICATION FORM
        **Please read these instructions very carefully. This is the template to fill out when you apply.**
        Please be as thorough as you can - it will help us get to know you better.
        Please create a NEW THREAD in this Recruitment forum for your application, with your NAME and CLASS/SPEC in the title.
        Literacy counts! Some of us are curmudgeons about the l33t sp34k.

        -----

        ##### CHARACTER AND HISTORY
        Character name, class, and spec:
        Character armory link:
        Which previous guilds did you belong to, and why did you leave them?
        Please give us a little insight into your main WoW character:
        Do you have an authenticator?

        ##### GUILD EXPERIENCE
        Have you read the Guild's Code of Conduct and Policies? Do these appeal to you and why?
        Why did you apply to My other Mount is Tauren, and how did you hear about us?
        What are you looking for in our guild, and what can you bring to the guild?

        ##### RAID EXPERIENCE
        Are you interested in raiding with our crew? _If no, you can skip the rest of this section._
        If so, what kind of raiding environment do you perform well in?
        Times you are available for raiding (Please be clear about time zones!):
        What are your recent raiding experiences?
        If you have it, please link a fairly recent combat log (preferably on current content):

        ##### SOCIAL QUESTIONS
        What do you love about your character's class?
        What has been your biggest thrill in WoW?
        Tell us a little about the real you, the person behind the character:

        (And the two most important questions...)
        Do you like cake or pie?
        Cats or dogs?"
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
